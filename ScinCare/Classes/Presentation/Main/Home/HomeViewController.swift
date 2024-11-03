//
//  HomeViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 21.10.2024.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    private lazy var mainView = HomeView()
    
    private lazy var viewModel = HomeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: HomeViewModel.Input(
            didTapMenu: mainView.menuButton.rx.tap.asSignal(),
            didTapExplore: mainView.collectionView.didTapExplore,
            didOpenScanner: mainView.collectionView.didOpenScanner,
            didOpenHistory: mainView.collectionView.didOpenHistory
        ))
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
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
extension HomeViewController {
    static func make() -> HomeViewController {
        let vc = HomeViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension HomeViewController {
    func route(_ route: HomeViewModel.Route) {
        switch route {
        case .menu:
            let vc = MenuViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .catalogs(let item):
            let vc = CatalogsViewController.make(item: item)
            navigationController?.pushViewController(vc, animated: true)
        case .openScanner:
            AnalyseScanAssembly().scan(from: self)
        case .openHistory:
            let vc = ScanHistoryViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
