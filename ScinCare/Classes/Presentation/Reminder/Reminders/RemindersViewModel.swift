//
//  RemindersViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 09.11.2024.
//

import RxSwift
import RxCocoa

final class RemindersViewModel {
    enum Route {
        case addEvent
        case open(Reminder)
    }
    
    private lazy var reminderManager = ReminderManager()
}

// MARK: Public
extension RemindersViewModel {
    struct Input {
        let didTapAddEvent: Signal<Void>
        let didSelect: Signal<Reminder>
        let selectedDate: Signal<Date>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[RemindersTableElement]>
        let reminders: Driver<[Reminder]>
        let isEmpty: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let selectedDate = input.selectedDate
            .startWith(.init())
        let reminders = makeReminders()
        let filteredReminders = makeReminders(reminders: reminders, for: selectedDate)
        let elements = makeElements(reminders: filteredReminders)
        
        return Output(
            route: makeRoute(
                didTapAddEvent: input.didTapAddEvent,
                didSelect: input.didSelect
            ),
            elements: elements,
            reminders: reminders,
            isEmpty: makeIsEmpty(elements: elements)
        )
    }
}

// MARK: Private
private extension RemindersViewModel {
    func makeRoute(
        didTapAddEvent: Signal<Void>,
        didSelect: Signal<Reminder>
    ) -> Driver<Route> {
        let addEvent = didTapAddEvent
            .map { Route.addEvent }
            .asDriver(onErrorDriveWith: .never())
        
        let open = didSelect
            .map { Route.open($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(addEvent, open)
    }
    
    func makeElements(reminders: Driver<[Reminder]>) -> Driver<[RemindersTableElement]> {
        reminders
            .map { reminders -> [RemindersTableElement] in
                var elements = [RemindersTableElement]()
                
                if !reminders.isEmpty {
                    elements.append(.add)
                }
                
                let sorted = reminders
                    .sorted(by: { $0.created > $1.created })
                    .map { RemindersTableElement.reminder($0) }
                elements.append(contentsOf: sorted)
                
                return elements
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeReminders(reminders: Driver<[Reminder]>, for date: Signal<Date>) -> Driver<[Reminder]> {
        Observable
            .combineLatest(
                reminders.asObservable(),
                date.asObservable()
            ) { reminders, date -> [Reminder] in
                reminders.filter { $0.isEvent(for: date) }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeReminders() -> Driver<[Reminder]> {
        let trigger = Signal
            .merge(
                RemindersMediator.shared.didAddReminder.map { _ in Void() },
                RemindersMediator.shared.didEditReminder.map { _ in Void() },
                RemindersMediator.shared.didDelete.map { _ in Void() }
            )
            .startWith(())
        
        return trigger
            .flatMapLatest { [weak self] void -> Driver<[Reminder]> in
                guard let self else { return .never() }
                
                return reminderManager
                    .reminders()
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeIsEmpty(elements: Driver<[RemindersTableElement]>) -> Driver<Bool> {
        elements
            .map { $0.isEmpty }
            .startWith(false)
    }
}
