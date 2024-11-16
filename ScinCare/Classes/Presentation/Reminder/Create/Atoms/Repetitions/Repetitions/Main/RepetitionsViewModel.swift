//
//  RepetitionsViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 12.11.2024.
//

import RxSwift
import RxCocoa

final class RepetitionsViewModel {
    enum Route {
        case close
        case count(RepetitionCountType)
        case everyDay
        case specificDate
        case everyMonth
        case everyYear
        case next(Repetition)
    }
    
    private let event: Driver<Reminder.Event>
    private let initial: Driver<RepetitionsTableElement.Repetition?>
    
    init(event: Reminder.Event, initial: RepetitionsTableElement.Repetition?) {
        self.event = BehaviorRelay(value: event).asDriver()
        self.initial = BehaviorRelay(value: initial).asDriver()
    }
}

// MARK: Public
extension RepetitionsViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didSelect: Signal<RepetitionsTableElement>
        let didTapConfirm: Signal<Void>
        let currentRepetition: Signal<Repetition>
    }
    
    struct Output {
        let elements: Driver<[RepetitionsTableElement]>
        let route: Signal<Route>
        let isEnableConfirm: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let selectedRepetition = makeSelectedRepetition(
            initial: initial,
            didSelect: input.didSelect
        )
        
        return Output(
            elements: makeElements(
                event: event,
                initial: initial
            ),
            route: makeRoute(
                didTapClose: input.didTapClose,
                selectedRepetition: selectedRepetition,
                didTapConfirm: input.didTapConfirm,
                currentRepetition: input.currentRepetition
            ),
            isEnableConfirm: makeIsEnableConfirm(selectedRepetition: selectedRepetition)
        )
    }
}

// MARK: Private
private extension RepetitionsViewModel {
    func makeElements(
        event: Driver<Reminder.Event>,
        initial: Driver<RepetitionsTableElement.Repetition?>
    ) -> Driver<[RepetitionsTableElement]> {
        Driver
            .combineLatest(event, initial)
            .map { event, initial -> [RepetitionsTableElement] in
                switch event {
                case .medication:
                    return [
                        RepetitionsTableElement(
                            repetition: .everyDay,
                            marked: initial == .everyDay
                        ),
                        RepetitionsTableElement(
                            repetition: .everyMinutes,
                            marked: initial == .everyMinutes
                        ),
                        RepetitionsTableElement(
                            repetition: .everyHours,
                            marked: initial == .everyHours
                        ),
                        RepetitionsTableElement(
                            repetition: .everyDays,
                            marked: initial == .everyDays
                        ),
                        RepetitionsTableElement(
                            repetition: .everyMonth,
                            marked: initial == .everyMonth
                        )
                    ]
                case .skinRescan:
                    return [
                        RepetitionsTableElement(
                            repetition: .everyMonth,
                            marked: initial == .everyMonth
                        ),
                        RepetitionsTableElement(
                            repetition: .everyDays,
                            marked: initial == .everyDays
                        ),
                        RepetitionsTableElement(
                            repetition: .everyYear,
                            marked: initial == .everyYear
                        ),
                        RepetitionsTableElement(
                            repetition: .onSpecificDate,
                            marked: initial == .onSpecificDate
                        ),
                    ]
                }
            }
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        selectedRepetition: Driver<RepetitionsTableElement.Repetition?>,
        didTapConfirm: Signal<Void>,
        currentRepetition: Signal<Repetition>
    ) -> Signal<Route> {
        let close = didTapClose
            .map { Route.close }
        
        let sheet = selectedRepetition
            .compactMap { value -> Route? in
                switch value {
                case .everyDay:
                    return .everyDay
                case .everyMinutes:
                    return .count(.minutes)
                case .everyHours:
                    return .count(.hours)
                case .everyDays:
                    return .count(.days)
                case .everyMonth:
                    return .everyMonth
                case .everyYear:
                    return .everyYear
                case .onSpecificDate:
                    return .specificDate
                case .none:
                    return nil
                }
            }
            .asSignal(onErrorSignalWith: .empty())
        
        let next = didTapConfirm
            .asObservable()
            .withLatestFrom(currentRepetition) { _, item in
                Route.next(item)
            }
            .asSignal(onErrorSignalWith: .empty())
        
        return Signal
            .merge(close, sheet, next)
    }
    
    func makeIsEnableConfirm(selectedRepetition: Driver<RepetitionsTableElement.Repetition?>) -> Driver<Bool> {
        selectedRepetition.map { $0 != nil }
    }
    
    func makeSelectedRepetition(
        initial: Driver<RepetitionsTableElement.Repetition?>,
        didSelect: Signal<RepetitionsTableElement>
    ) -> Driver<RepetitionsTableElement.Repetition?> {
        let selected = didSelect
            .asDriver(onErrorDriveWith: .never())
            .map { element -> RepetitionsTableElement.Repetition? in element.repetition }
        
        return Driver
            .merge(initial, selected)
    }
}
