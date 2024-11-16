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
    
    let initial: Reminder
    
    init(initial: Reminder? = nil, event: Reminder.Event) {
        if let initial {
            self.initial = initial
        } else {
            self.initial = .init(
                id: UUID().uuidString,
                created: .init(),
                event: event,
                name: "",
                trigger: .everyDay(.init()),
                note: nil
            )
        }
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
    }
    
    enum Action {
        case add(Repetition)
        case change(Date)
    }
    
    struct Output {
        let route: Signal<Route>
        let reminder: Driver<Reminder>
        let isEnabled: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let changedDate = input.changedDate
            .withLatestFrom(input.repetition) { date, repetition in
                return repetition?.changed(date: date)
            }
        
        let changedCount = input.changedCount
            .asObservable()
            .withLatestFrom(input.repetition) { count, repetition in
                return repetition?.changed(count: count)
            }
        
        let currentRepetition = Observable
            .merge(
                input.repetition,
                changedDate,
                changedCount
            )
            .compactMap { $0 }
            .startWith(initial.trigger)
            .share(replay: 1)
    
        let note = input.note
            .startWith(nil)
            .distinctUntilChanged()
        
        let name = input.name
            .map { $0 ?? "" }
            .startWith("")
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
            .map { !$0.name.isEmpty }
        
        // TODO: Добавить сохранение
        let saveReminder = input.didTapNext
            .asObservable()
            .withLatestFrom(reminder)
            
        
        return Output(
            route: makeRoute(
                didTapBack: input.didTapBack,
                didTapClose: input.didTapClose,
                didTapChangeCount: input.changeCount,
                currentRepetition: currentRepetition
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
        currentRepetition: Observable<Repetition>
    ) -> Signal<Route> {
        let back = didTapBack
            .map { Route.back }
        
        let close = didTapClose
            .map { Route.close }
        
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
            .merge(back, close, changeCount)
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
