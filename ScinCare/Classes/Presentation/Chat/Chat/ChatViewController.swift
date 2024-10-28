//
//  ChatViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import UIKit
import RxSwift

final class ChatViewController: UIViewController {
    private lazy var mainView = ChatView()
    
    private lazy var viewModel = ChatViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: ChatViewModel.Input(
            didTapHistory: mainView.historyButton.rx.tap.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ChatViewController {
    static func make() -> ChatViewController {
        let vc = ChatViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension ChatViewController {
    func route(_ route: ChatViewModel.Route) {
        switch route {
        case .history:
            break
        }
    }
}
