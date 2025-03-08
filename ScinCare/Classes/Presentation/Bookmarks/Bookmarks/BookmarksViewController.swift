//
//  BookmarksViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class BookmarksViewController: UIViewController {
    enum NavigationMode {
        case normal, editable
    }
    
    private lazy var mainView = BookmarksView()
    
    private lazy var viewModel = BookmarksViewModel()
    
    private lazy var didTapDeleteTrigger = PublishRelay<Void>()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        let didTapFilter = Observable
            .merge(
                mainView.filterView
                    .proceduresButton.rx.tap
                    .map { BookmarksFilterView.Filter.procedures },
                mainView.filterView
                    .diseasesButton.rx.tap
                    .map { BookmarksFilterView.Filter.diseases },
                mainView.filterView
                    .glossariesButton.rx.tap
                    .map { BookmarksFilterView.Filter.glossaries }
            )
            .asSignal(onErrorSignalWith: .never())
            .startWith(.procedures)
        
        didTapFilter
            .emit(to: Binder(mainView.filterView) { base, filter in
                base.filter = filter
            })
            .disposed(by: disposeBag)
        
        mainView.deleteButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.confirmDelete()
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: BookmarksViewModel.Input(
            didTapFilter: didTapFilter,
            didTapDone: mainView.doneButton.rx.tap.asSignal(),
            didTapEdit: mainView.editButton.rx.tap.asSignal(),
            didTapDelete: didTapDeleteTrigger.asSignal(),
            didTapCatalog: mainView.tableView.didTapCatalog
        ))
        
        output.isEmpty
            .drive(Binder(self) { base, unit in
                base.isEmpty(unit: unit)
            })
            .disposed(by: disposeBag)
        
        output.navigationMode
            .drive(Binder(mainView) { base, mode in
                base.navigationMode(mode)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.hasSelectedOnCurrentFilter
            .drive(Binder(mainView.deleteButton) { base, enable in
                base.isEnabled = enable
                base.alpha = enable ? 1 : 0.5
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.disposable
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension BookmarksViewController {
    static func make() -> BookmarksViewController {
        let vc = BookmarksViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension BookmarksViewController {
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func isEmpty(unit: BookmarksEmptyView.Unit?) {
        mainView.navigationsActionsContainer.isHidden = unit != nil
        
        mainView.emptyView.isHidden = unit == nil
        mainView.tableView.isHidden = unit != nil
        
        if let unit = unit {
            mainView.emptyView.setup(unit: unit)
        }
    }
    
    func confirmDelete() {
        let vc = CDBViewController.make { [weak self] in
            self?.didTapDeleteTrigger.accept(Void())
        }
        present(vc, animated: false)
    }
    
    func route(_ route: BookmarksViewModel.Route) {
        switch route {
        case .catalog(let item, let catalog):
            let vc = CatalogDetailsViewController.make(item: item, catalog: catalog)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
