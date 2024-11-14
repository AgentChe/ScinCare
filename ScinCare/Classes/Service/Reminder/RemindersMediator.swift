//
//  RemindersMediator.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 09.11.2024.
//

import RxSwift
import RxCocoa

final class RemindersMediator {
    static let shared = RemindersMediator()
    
    private init() {}
    
    private lazy var didAddReminderTrigger = PublishRelay<Reminder>()
    private lazy var didEditReminderTrigger = PublishRelay<Reminder>()
    private lazy var didDeleteTrigger = PublishRelay<String>()
}

// MARK: Public
extension RemindersMediator {
    func add(reminder: Reminder) {
        didAddReminderTrigger.accept(reminder)
    }
    
    func edit(reminder: Reminder) {
        didEditReminderTrigger.accept(reminder)
    }
    
    func delete(id: String) {
        didDeleteTrigger.accept(id)
    }
    
    var didAddReminder: Signal<Reminder> {
        didAddReminderTrigger.asSignal()
    }
    
    var didEditReminder: Signal<Reminder> {
        didEditReminderTrigger.asSignal()
    }
    
    var didDelete: Signal<String> {
        didDeleteTrigger.asSignal()
    }
}
