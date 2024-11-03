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
        case reminder
        case later
    }
    
    private lazy var mainView = SaveAnalyseCompleteView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let result: (Result) -> Void
    
    private init(result: @escaping (Result) -> Void) {
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
                    .map { Result.reminder },
                mainView.laterButton.rx.tap
                    .map { Result.later }
            )
            .bind(to: Binder(self) { base, result in
                base.result(result)
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
    static func make(result: @escaping (Result) -> Void) -> SaveAnalyseCompleteViewController {
        let vc = SaveAnalyseCompleteViewController(result: result)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}
