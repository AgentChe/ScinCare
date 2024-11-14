//
//  RepetitionsTableElement.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 12.11.2024.
//

final class RepetitionsTableElement {
    enum Repetition: Equatable {
        case everyDay
        case everyMinutes
        case everyHours
        case everyDays
        case everyMonth
        case everyYear
        case onSpecificDate
    }
    
    let repetition: Repetition
    let localizedTitle: String
    var marked: Bool
    
    init(
        repetition: Repetition,
        marked: Bool
    ) {
        self.repetition = repetition
        self.localizedTitle = {
            switch repetition {
            case .everyDay:
                return "Repetitions.EveryDay".localized
            case .everyMinutes:
                return "Repetitions.EveryMinutes".localized
            case .everyHours:
                return "Repetitions.EveryHours".localized
            case .everyDays:
                return "Repetitions.EveryDays".localized
            case .everyMonth:
                return "Repetitions.EveryMonth".localized
            case .everyYear:
                return "Repetitions.EveryYear".localized
            case .onSpecificDate:
                return "Repetitions.OnSpecificDate".localized
            }
        }()
        self.marked = marked
    }
}
