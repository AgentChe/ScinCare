//
//  CREViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 11.11.2024.
//

import RxSwift

final class CREViewController: UIViewController {
    enum Result {
        case close
        case medication
        case skinRescan
    }
    
    private lazy var mainView = CREView()
    
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
                mainView.closeButton.rx.tap
                    .map { Result.close },
                
                mainView.medicationButton.rx.tap
                    .map { Result.medication },
                
                mainView.skinRescanButton.rx.tap
                    .map { Result.skinRescan }
            )
            .bind(to: Binder(self) { base, result in
                base.result(result)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CREViewController {
    static func make(result: @escaping (Result) -> Void) -> CREViewController {
        let vc = CREViewController(result: result)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}
