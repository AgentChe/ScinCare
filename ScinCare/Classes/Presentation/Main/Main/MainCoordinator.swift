//
//  MainCoordinator.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import UIKit

final class MainCoordinator {
    weak var parentVC: MainViewController?
    
    lazy var assistantVC = NavigationController(rootViewController: UIViewController())
    lazy var accountVC = NavigationController(rootViewController: UIViewController())
    
    private var previousVC: UIViewController?
    
    init(parentVC: MainViewController) {
        self.parentVC = parentVC
    }
    
    func change(tab: TabView.Tab) {
        parentVC?.mainView.tabView.selectedTab = tab
        
        switch tab {
        case .recognizer:
            return
        case .assistant:
            changeVC(on: assistantVC)
        case .account:
            changeVC(on: accountVC)
        }
    }
}

// MARK: Private
private extension MainCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC = self.parentVC else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = parentVC.mainView.container.bounds
        parentVC.mainView.container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
