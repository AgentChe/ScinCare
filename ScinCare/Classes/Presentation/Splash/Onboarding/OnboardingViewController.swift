//
//  OnboardingViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingViewController: UIViewController {
    struct Constants {
        static let wasViewedKey = "onboarding_view_controller_was_viewed_key"
    }
    
    private lazy var mainView = OnboardingView { [weak self] in
        guard let self else { return }
        
        markAsViewed()
        goNext()
    }
    
    override func loadView() {
        view = mainView
    }
}

// MARK: Public
extension OnboardingViewController {
    static func make() -> OnboardingViewController {
        OnboardingViewController()
    }
    
    static func wasViewed() -> Bool {
        UserDefaults.standard.bool(forKey: OnboardingViewController.Constants.wasViewedKey)
    }
}

// MARK: Private
private extension OnboardingViewController {
    func markAsViewed() {
        UserDefaults.standard.setValue(true, forKey: Constants.wasViewedKey)
    }
    
    func goNext() {
        if SessionManager().hasActiveSubscriptions() {
            UIApplication.shared.keyWindow?.rootViewController = MainViewController.make()
        } else {
            let vc = PaygateViewController.make {
                UIApplication.shared.keyWindow?.rootViewController = MainViewController.make()
            }
            present(vc, animated: true)
        }
    }
}
