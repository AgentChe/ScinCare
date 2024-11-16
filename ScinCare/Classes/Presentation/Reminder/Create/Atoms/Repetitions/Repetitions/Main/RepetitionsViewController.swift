//
//  RepetitionsViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 12.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class RepetitionsViewController: UIViewController {
    struct Bundle {
        let event: Reminder.Event
        let initial: RepetitionsTableElement.Repetition?
    }
    
    enum Result {
        case close
        case repetition(Repetition)
    }
    
    private lazy var mainView = RepetitionsView()
    
    private let viewModel: RepetitionsViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private let result: (Result) -> Void
    
    private lazy var repetitionRelay = PublishRelay<Repetition>()
    
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
            didTapConfirm: mainView.confirmButton.rx.tap.asSignal(),
            currentRepetition: repetitionRelay.asSignal()
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.route
            .emit(with: self) { $0.route($1) }
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
        case let .next(repetition):
            result(.repetition(repetition))
        case let .count(type):
            openCountSheet(for: type)
        case .specificDate:
            openCalendarSheet(min: .init()) { [weak self] in
                self?.repetitionRelay.accept(.onSpecificDate($0))
                self?.dismiss(animated: true)
            }
        case .everyDay:
            openTimeSheet()
        case .everyMonth:
            let current = Date()
            openCalendarSheet(min: current.firstDayInMonth, max: current.endDayInMonth) { [weak self] in
                self?.repetitionRelay.accept(.everyMonth($0))
                self?.dismiss(animated: true)
            }
        case .everyYear:
            openCalendarSheet { [weak self] in
                self?.repetitionRelay.accept(.everyYear($0))
                self?.dismiss(animated: true)
            }
        }
    }
    
    func openCountSheet(for type: RepetitionCountType) {
        let vc = RepetitionCountPickerViewController.make(type: type) { [weak self] in
            switch type {
            case .minutes:
                self?.repetitionRelay.accept(.everyMinutes($0))
            case .hours:
                self?.repetitionRelay.accept(.everyHours($0))
            case .days:
                self?.repetitionRelay.accept(.everyDays($0))
            }
            
            self?.dismiss(animated: true)
        }
        
        let nv = UINavigationController(rootViewController: vc)
        if let sheet = nv.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 16.scale
        }
        
        present(nv, animated: true)
    }
    
    
    func openCalendarSheet(min: Date? = nil, max: Date? = nil, action: @escaping (Date) -> Void) {
        let vc = RepetitionSpecificDayViewController.make(min: min, max: max, didSaveDate: action)
        let nv = UINavigationController(rootViewController: vc)
        nv.setNavigationBarHidden(true, animated: false)
        nv.modalPresentationStyle = .pageSheet
        
        if let sheet = nv.sheetPresentationController {
            sheet.detents = [.custom { _ in 489.scale }]
            sheet.preferredCornerRadius = 16.scale
        }
        
        present(nv, animated: true)
    }
    
    func openTimeSheet() {
        let vc = RepetitionEveryDayViewController.make { [weak self] in
            self?.repetitionRelay.accept(.everyDay($0))
            self?.dismiss(animated: true)
        }
        
        let nv = UINavigationController(rootViewController: vc)
        if let sheet = nv.sheetPresentationController {
            sheet.detents = [.custom { _ in
                return 300.scale
            }]
            sheet.preferredCornerRadius = 16.scale
        }
        
        present(nv, animated: true)
    }
}

private extension Date {
    var firstDayInMonth: Date? {
        let components = Calendar.current.dateComponents([.year, .month], from: .init())
        return Calendar.current.date(from: components)
    }
    
    var endDayInMonth: Date? {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return firstDayInMonth.flatMap { Calendar.current.date(byAdding: components, to: $0) }
    }
}
