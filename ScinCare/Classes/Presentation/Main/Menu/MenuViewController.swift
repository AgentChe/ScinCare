//
//  MenuViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class MenuViewController: UIViewController {
    private lazy var mainView = MenuView()
    
    private lazy var viewModel = MenuViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuRoute = Signal<MenuRouteButton.Route>
            .merge(
                mainView.disclaimerButton.rx.tap.asSignal().map { .disclaimer },
                mainView.termsOfUseButton.rx.tap.asSignal().map { .termsOfUse },
                mainView.privacyPolicyButton.rx.tap.asSignal().map { .privacyPolicy },
                mainView.supportButton.rx.tap.asSignal().map { .support }
            )
        
        let output = viewModel.configure(input: MenuViewModel.Input(
            didTapMenuRoute: menuRoute
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension MenuViewController {
    static func make() -> MenuViewController {
        let vc = MenuViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Menu.Title".localized
        return vc
    }
}

// MARK: Private
private extension MenuViewController {
    func route(_ route: MenuViewModel.Route) {
        switch route {
        case .disclaimer:
            let vc = DisclaimerViewController.make()
            present(vc, animated: true)
        case .open(let url):
            UIApplication.shared.open(url)
        }
    }
}
