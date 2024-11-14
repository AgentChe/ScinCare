//
//  CMRViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 11.11.2024.
//

import UIKit
import RxSwift

final class CMRViewController: UIViewController {
    enum Result {
        case back
        case close
    }
    
    private lazy var mainView = CMRView(vc: self)
    
    private lazy var viewModel = CMRViewModel()
    
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
        
        let output = viewModel.configure(input: CMRViewModel.Input(
            didTapBack: mainView.backButton.rx.tap.asSignal(),
            didTapClose: mainView.closeButton.rx.tap.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CMRViewController {
    static func make(result: @escaping (Result) -> Void) -> CMRViewController {
        let vc = CMRViewController(result: result)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension CMRViewController {
    func route(_ route: CMRViewModel.Route) {
        switch route {
        case .back:
            result(.back)
        case .close:
            result(.close)
        }
    }
}
