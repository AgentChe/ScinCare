//
//  SaveAnalyseCompleteViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 03.11.2024.
//

import UIKit
import RxSwift

final class SaveAnalyseCompleteViewController: UIViewController {
    enum Result {
        case setNotification
        case later
    }
    
    private lazy var mainView = SaveAnalyseCompleteView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let result: (UIViewController, Result) -> Void
    
    private init(result: @escaping (UIViewController, Result) -> Void) {
        self.result = result
        
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
        
        Observable
            .merge(
                mainView.reminderButton.rx.tap
                    .map { Result.setNotification },
                mainView.laterButton.rx.tap
                    .map { Result.later }
            )
            .bind(to: Binder(self) { base, result in
                base.result(base, result)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mainView.animateShow()
    }
}

// MARK: Public
extension SaveAnalyseCompleteViewController {
    static func make(result: @escaping (UIViewController, Result) -> Void) -> SaveAnalyseCompleteViewController {
        let vc = SaveAnalyseCompleteViewController(result: result)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}
