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
                base.coordinator.change(tab: .home)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge([
                mainView.tabView.homeButton
                    .rx.tap.map { TabView.Tab.home },
                
                mainView.tabView.favoritesButton
                    .rx.tap.map { TabView.Tab.favorites },
                
                mainView.tabView.calendarButton
                    .rx.tap.map { TabView.Tab.calendar },
                
                mainView.tabView.chatButton
                    .rx.tap.map { TabView.Tab.chat }
            ])
            .bind(to: Binder(self) { base, tab in
                base.coordinator.change(tab: tab)
            })
            .disposed(by: disposeBag)
        
        mainView.tabView.scanButton
            .rx.tap.bind(to: (Binder(self) { base, void in
                AnalyseScanAssembly().scan(from: base)
            }))
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
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
