//
//  RepetitionsViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 12.11.2024.
//

import UIKit
import RxSwift

final class RepetitionsViewController: UIViewController {
    struct Bundle {
        let event: Reminder.Event
        let initial: RepetitionsTableElement.Repetition?
    }
    
    enum Result {
        case close
    }
    
    private lazy var mainView = RepetitionsView()
    
    private let viewModel: RepetitionsViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private let result: (Result) -> Void
    
    private init(inputBundle: Bundle, result: @escaping (Result) -> Void) {
        self.viewModel = RepetitionsViewModel(
            event: inputBundle.event,
            initial: inputBundle.initial
        )
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
        
        let output = viewModel.configure(input: RepetitionsViewModel.Input(
            didTapClose: mainView.closeButton.rx.tap.asSignal(),
            didSelect: mainView.tableView.didSelect,
            didTapConfirm: mainView.confirmButton.rx.tap.asSignal()
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.isEnableConfirm
            .drive(Binder(mainView.confirmButton) { base, isEnableConfirm in
                base.isEnabled = isEnableConfirm
                base.alpha = isEnableConfirm ? 1 : 0.5
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension RepetitionsViewController {
    static func make(inputBundle: Bundle, result: @escaping (Result) -> Void) -> RepetitionsViewController {
        RepetitionsViewController(inputBundle: inputBundle, result: result)
    }
}

// MARK: Private
private extension RepetitionsViewController {
    func route(_ route: RepetitionsViewModel.Route) {
        switch route {
        case .close:
            result(.close)
        }
    }
}
