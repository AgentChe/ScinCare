//
//  ReminderRegisterManager.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 18.11.2024.
//

import UserNotifications
import RxSwift
import RxCocoa

final class ReminderRegisterManager {
    static let shared = ReminderRegisterManager()
    
    private lazy var reminderManager = ReminderManager()
    
    private lazy var center = UNUserNotificationCenter.current()
    
    private lazy var disposeBag = DisposeBag()
    
    private init() {}
}

// MARK: Public
extension ReminderRegisterManager {
    func initialize() {
        Signal
            .merge(
                RemindersMediator.shared.didAddReminder.map { _ in Void() },
                RemindersMediator.shared.didEditReminder.map { _ in Void() },
                RemindersMediator.shared.didDelete.map { _ in Void() }
            )
            .flatMapLatest { [weak self] void -> Signal<[Reminder]> in
                guard let self else { return .never() }
                
                return reminderManager
                    .reminders()
                    .asSignal(onErrorJustReturn: [])
            }
            .emit(to: Binder(self) { base, reminders in
                base.register(reminders: reminders)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension ReminderRegisterManager {
    func register(reminders: [Reminder]) {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        
        let calendar = Calendar.current
        
        reminders.forEach { reminder in
            let content = UNMutableNotificationContent()
            content.body = reminder.name
            
            let trigger: UNNotificationTrigger = {
                switch reminder.trigger {
                case .everyDay(let date):
                    let components = calendar.dateComponents([.hour, .minute], from: date)
                    return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                case .everyMinutes(let minutes):
                    let interval = TimeInterval(minutes) * 60
                    return UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
                case .everyHours(let hours):
                    let interval = TimeInterval(hours) * 60 * 60
                    return UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
                case .everyDays(let days):
                    var components = DateComponents()
                    components.day = days
                    return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                case .everyMonth(let date):
                    let components = calendar.dateComponents([.day, .hour, .minute], from: date)
                    return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                case .everyYear (let date):
                    let components = calendar.dateComponents([.month, .day, .hour, .minute], from: date)
                    return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                case .onSpecificDate(let date):
                    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                }
            }()
            
            let request = UNNotificationRequest(
                identifier: reminder.id,
                content: content,
                trigger: trigger
            )
            
            center.add(request)
        }
    }
}
