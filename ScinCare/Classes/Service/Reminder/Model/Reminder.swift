//
//  Reminder.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 09.11.2024.
//

import Foundation

struct Reminder: Codable {
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
