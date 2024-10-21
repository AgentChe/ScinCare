//
//  MainViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    lazy var mainView = MainView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = MainCoordinator(parentVC: self)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, _ in
                base.coordinator.change(tab: .assistant)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge([
                mainView.tabView.assistantButton
                    .rx.tap.map { TabView.Tab.assistant },
                
                mainView.tabView.accountButton
                    .rx.tap.map { TabView.Tab.account }
            ])
            .bind(to: Binder(self) { base, tab in
                base.coordinator.change(tab: tab)
            })
            .disposed(by: disposeBag)
        
        mainView.tabView.recognizerButton
            .rx.tap.bind(to: (Binder(self) { base, void in
                
            }))
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Public
extension MainViewController {
    static func make() -> MainViewController {
        let vc = MainViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}
