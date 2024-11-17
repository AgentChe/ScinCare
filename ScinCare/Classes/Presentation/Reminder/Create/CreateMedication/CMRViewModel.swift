//
//  CMRViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 11.11.2024.
//

import RxSwift
import RxCocoa

final class CMRViewModel {
    enum Route {
        case back
        case close
        case counter(RepetitionCountType)
    }
    
    let mode: CMRViewController.Mode
    private let initial: Reminder
    private lazy var reminderManager = ReminderManager()
    
    init(mode: CMRViewController.Mode) {
        switch mode {
        case .edit(let reminder):
            self.initial = reminder
        case .create(let event):
            self.initial = .init(
                id: UUID().uuidString,
                created: .init(),
                event: event,
                name: "",
                trigger: .everyDay(.init()),
                note: nil
            )
        }
        self.mode = mode
    }
}

// MARK: Public
extension CMRViewModel {
    struct Input {
        let didTapBack: Signal<Void>
        let didTapClose: Signal<Void>
        let didTapNext: Signal<Void>
        let name: Observable<String?>
        let note: Observable<String?>
        let repetition: Observable<Repetition?>
        let changedDate: Observable<Date>
        let changeCount: Signal<Void>
        let changedCount: Signal<Int>
        let didTapDelete: Signal<Void>
    }
    
    struct Output {
        let route: Signal<Route>
        let reminder: Driver<Reminder>
        let isEnabled: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let repetition = input.repetition
            .compactMap { $0 }
            .startWith(initial.trigger)
            .share(replay: 1)
        
        let changedDate = input.changedDate
            .skip(1)
            .withLatestFrom(repetition) { date, repetition in
                return repetition.changed(date: date)
            }
        
        let changedCount = input.changedCount
            .asObservable()
            .withLatestFrom(repetition) { count, repetition in
                return repetition.changed(count: count)
            }
        
        let currentRepetition = Observable
            .merge(
                repetition.map { $0 },
                changedDate,
                changedCount
            )
            .compactMap { $0 }
            .share(replay: 1)
    
        let note = input.note
            .skip(1)
            .startWith(initial.note)
            .distinctUntilChanged()
        
        let name = input.name
            .skip(1)
            .compactMap { $0 }
            .startWith(initial.name)
            .distinctUntilChanged()
        
        let reminder = Observable
            .combineLatest(
                currentRepetition,
                name,
                note
            )
            .map { [initial] repetition, name, note in
                return Reminder(
                    id: initial.id,
                    created: initial.created,
                    event: initial.event,
                    name: name,
                    trigger: repetition,
                    note: note
                )
            }
            .asDriver(onErrorJustReturn: initial)
        
        let isEnabled = reminder
            .map { [mode] reminder in
                switch mode {
                case .create:
                    return !reminder.name.isEmpty
                case .edit(let initial):
                    return initial != reminder && !reminder.name.isEmpty
                }
            }
        
        let didSave = input.didTapNext
            .asObservable()
            .withLatestFrom(reminder)
            .flatMapFirst { [reminderManager, mode] reminder in
                switch mode {
                case .edit:
                    return reminderManager.change(reminder: reminder)
                case .create:
                    return reminderManager.add(reminder: reminder).map { $0 }
                }
            }
            .mapToVoid()
            .asSignal(onErrorSignalWith: .never())
        
        let didDelete = input.didTapDelete
            .asObservable()
            .withLatestFrom(reminder)
            .flatMapFirst { [reminderManager] reminder in
                return reminderManager.delete(id: reminder.id)
            }
            .asSignal(onErrorSignalWith: .never())
        
        return Output(
            route: makeRoute(
                didTapBack: input.didTapBack,
                didTapClose: input.didTapClose,
                didTapChangeCount: input.changeCount,
                currentRepetition: currentRepetition,
                saveOrDelete: .merge(didSave, didDelete)
            ),
            reminder: reminder,
            isEnabled: isEnabled
        )
    }
}

// MARK: Private
extension CMRViewModel {
    func makeRoute(
        didTapBack: Signal<Void>,
        didTapClose: Signal<Void>,
        didTapChangeCount: Signal<Void>,
        currentRepetition: Observable<Repetition>,
        saveOrDelete: Signal<Void>
    ) -> Signal<Route> {
        let back = didTapBack
            .map { Route.back }
        
        let close = didTapClose
            .map { Route.close }
        
        let saveOrDelete = saveOrDelete
            .map { _ in Route.close }
        
        let changeCount = didTapChangeCount
            .asObservable()
            .withLatestFrom(currentRepetition)
            .compactMap { repetition -> Route? in
                switch repetition {
                case .everyMinutes:
                    return .counter(.minutes)
                case .everyHours:
                    return .counter(.hours)
                case .everyDays:
                    return .counter(.days)
                default:
                    return nil
                }
            }
            .asSignal(onErrorSignalWith: .never())
        
        return Signal
            .merge(back, close, changeCount, saveOrDelete)
    }
}

private extension Repetition {
    func changed(date: Date) -> Self? {
        switch self {
        case .everyDay:
            return .everyDay(date)
        case .everyMonth:
            return .everyMonth(date)
        case .everyYear:
            return .everyYear(date)
        case .onSpecificDate:
            return .onSpecificDate(date)
        case .everyMinutes, .everyHours, .everyDays:
            return nil
        }
    }
    
    func changed(count: Int) -> Self? {
        switch self {
        case .everyDay, .everyMonth, .everyYear, .onSpecificDate:
            return nil
        case .everyMinutes:
            return .everyMinutes(count)
        case .everyHours:
            return .everyHours(count)
        case .everyDays:
            return .everyDays(count)
        }
    }
}
