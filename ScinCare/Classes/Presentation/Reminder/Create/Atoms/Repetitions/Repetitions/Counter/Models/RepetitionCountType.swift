//
//  RepetitionCountType.swift
//  ScinCare
//
//  Created by Vitaliy Zagorodnov on 15.11.2024.
//

import Foundation

enum RepetitionCountType {
    case minutes
    case hours
    case days
}

extension RepetitionCountType {
    var title: String {
        switch self {
        case .minutes:
            "Repetitions.EveryMinutes" .localized
        case .hours:
            "Repetitions.EveryHours".localized
        case .days:
            "Repetitions.EveryDays".localized
        }
    }
    
    var right: String {
        switch self {
        case .minutes:
            "Repetitions.Minutes".localized
        case .hours:
            "Repetitions.Hours".localized
        case .days:
            "Repetitions.Days".localized
        }
    }
    
    var dataSource: [Int] {
        switch self {
        case .minutes:
            Array(1...360)
        case .hours:
            Array(1...12)
        case .days:
            Array(1...30)
        }
    }
}
