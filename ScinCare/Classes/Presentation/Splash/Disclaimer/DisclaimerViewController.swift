//
//  DisclaimerViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 21.10.2024.
//

import UIKit
import RxSwift

final class DisclaimerViewController: UIViewController {
    lazy var mainView = DisclaimerView(buttonTitle: .ok)
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.button.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension DisclaimerViewController {
    static func make() -> DisclaimerViewController {
        let vc = DisclaimerViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
