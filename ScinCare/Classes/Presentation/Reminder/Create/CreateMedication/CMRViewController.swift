//
//  CMRViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 11.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CMRViewController: UIViewController {
    enum Result {
        case back
        case close
    }
    
    private lazy var mainView = CMRView(vc: self, event: viewModel.initial.event)
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var changedCountRelay = PublishRelay<Int>()
    
    private let viewModel: CMRViewModel
    
    private let result: (Result) -> Void
    
    private init(reminder: Reminder? = nil, event: Reminder.Event, result: @escaping (Result) -> Void) {
        self.result = result
        self.viewModel = .init(initial: reminder, event: event)
        
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
            didTapClose: mainView.closeButton.rx.tap.asSignal(),
            didTapNext: mainView.confirmButton.rx.tap.asSignal(),
            name: mainView.inputDataView.nameField.textField.rx.text.asObservable(),
            note: mainView.inputDataView.noteField.textField.rx.text.asObservable(),
            repetition: mainView.inputDataView.repetitionView.repetition,
            changedDate: mainView.inputDataView.reminderView.datePicker.rx.date.asObservable(),
            changeCount: mainView.inputDataView.reminderView.countButton.rx.tap.asSignal(),
            changedCount: changedCountRelay.asSignal()
        ))
        
        output.route
            .emit(with: self) { $0.route($1) }
            .disposed(by: disposeBag)
        
        output.reminder
            .map(\.trigger)
            .drive(mainView.inputDataView.reminderView.setup)
            .disposed(by: disposeBag)
        
        output.reminder
            .map(\.trigger)
            .drive(mainView.inputDataView.repetitionView.repetitionBinder)
            .disposed(by: disposeBag)
        
        output.reminder
            .map(\.name)
            .drive(mainView.inputDataView.nameField.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.reminder
            .map(\.note)
            .drive(mainView.inputDataView.noteField.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.isEnabled
            .drive(Binder(mainView.confirmButton) { base, isEnabled in
                base.isEnabled = isEnabled
                base.alpha = isEnabled ? 1 : 0.5
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CMRViewController {
    static func make(reminder: Reminder? = nil, event: Reminder.Event, result: @escaping (Result) -> Void) -> CMRViewController {
        let vc = CMRViewController(reminder: reminder, event: event, result: result)
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
        case let .counter(type):
            openCountSheet(for: type)
        }
    }
    
    func openCountSheet(for type: RepetitionCountType) {
        let vc = RepetitionCountPickerViewController.make(type: type) { [weak self] in
            self?.changedCountRelay.accept($0)
            self?.dismiss(animated: true)
        }
        
        let nv = UINavigationController(rootViewController: vc)
        if let sheet = nv.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 16.scale
        }
        
        present(nv, animated: true)
    }
}
