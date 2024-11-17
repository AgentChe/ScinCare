//
//  Reminder.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 09.11.2024.
//

import Foundation

struct Reminder: Codable, Equatable {
    enum Event: Codable {
        case medication
        case skinRescan
    }
    
    let id: String
    let created: Date
    let event: Event
    let name: String
    let trigger: Repetition
    let note: String?
}

enum Repetition: Codable, Equatable {
    case everyDay(Date) // Date - время уведомления
    case everyMinutes(Int)
    case everyHours(Int)
    case everyDays(Int)
    case everyMonth(Date) // Date - день уведомления
    case everyYear (Date) // Date - день уведомления
    case onSpecificDate(Date) // Date - день и время уведомления без повторения
}

extension Reminder {
    func isEvent(for date: Date) -> Bool {
        let calendar = Calendar.current
        switch trigger {
        case .everyMinutes, .everyHours, .everyDay:
            return true
        case let .everyMonth(event):
            return calendar.compare(event, to: date, toGranularity: .day) == .orderedSame
        case let .everyYear(event):
            guard
                let lhs = calendar.dateComponents([.day, .month], from: event).date,
                let rhs = calendar.dateComponents([.day, .month], from: date).date
            else { return false }
            return calendar.compare(lhs, to: rhs, toGranularity: .day) == .orderedSame
        case let .onSpecificDate(event):
            return calendar.compare(event, to: date, toGranularity: .day) == .orderedSame
        case let .everyDays(int):
            let from = calendar.startOfDay(for: created)
            let to = calendar.startOfDay(for: date)
            guard from < to else { return false }
            
            if let numberOfDays = calendar.dateComponents([.day], from: from, to: to).day {
                return numberOfDays % int == 0
            } else {
                return false
            }
        }
    }
}
