//
//  CatalogsViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import UIKit
import RxSwift

final class CatalogsViewController: UIViewController {
    enum Item {
        case glossary, procedure, disease
    }
    
    private lazy var mainView = CatalogsView(item: item)
    
    private lazy var viewModel = CatalogsViewModel(item: item)
    
    private lazy var disposeBag = DisposeBag()
    
    private let item: Item
    
    private init(item: Item) {
        self.item = item
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: CatalogsViewModel.Input(
            didTapBack: mainView.backButton.rx.tap.asSignal(),
            didSearch: mainView.searchField.changedText,
            didSelect: mainView.tableView.didSelect
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CatalogsViewController {
    static func make(item: Item) -> CatalogsViewController {
        let vc = CatalogsViewController(item: item)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension CatalogsViewController {
    func route(_ route: CatalogsViewModel.Route) {
        switch route {
        case .back:
            navigationController?.popViewController(animated: true)
        case .details(let element):
            if element.locked {
                let vc = PaygateViewController.make()
                present(vc, animated: true)
            } else {
                // TODO
//                let vc = TermViewController.make(term: element.term)
//                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
