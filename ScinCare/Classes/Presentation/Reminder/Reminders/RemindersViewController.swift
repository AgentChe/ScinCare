//
//  RemindersViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 09.11.2024.
//a

import UIKit
import RxSwift
import RxCocoa

final class RemindersViewController: UIViewController {
    private lazy var mainView = RemindersView()
    
    private lazy var viewModel = RemindersViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: RemindersViewModel.Input(
            didTapAddEvent: Signal
                .merge(
                    mainView.tableView.didTapAddEvent,
                    mainView.emptyView.addButton.rx.tap.asSignal()
                ),
            didSelect: mainView.tableView.didSelectReminder
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.isEmpty
            .drive(Binder(mainView) { base, isEmpty in
                base.tableView.isHidden = isEmpty
                base.emptyView.isHidden = !isEmpty
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension RemindersViewController {
    static func make() -> RemindersViewController {
        let vc = RemindersViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension RemindersViewController {
    func route(_ route: RemindersViewModel.Route) {
        switch route {
        case .addEvent:
            CreateReminderAssembly().create(from: self)
        case .open(let reminder):
            break // TODO
        }
    }
}
