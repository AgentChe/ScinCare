//
//  ReminderManager.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 09.11.2024.
//

import RxSwift
import RxCocoa

protocol ReminderManagerProtocol {
    func reminders() -> Single<[Reminder]>
    func add(reminder: Reminder) -> Single<Reminder>
    func change(reminder: Reminder) -> Single<Reminder?>
    func delete(id: String) -> Single<Void>
}

final class ReminderManager {
    enum Constants {
        static let remindersKey = "reminder_manager_reminders_key"
    }
}

// MARK: ReminderManagerProtocol
extension ReminderManager: ReminderManagerProtocol {
    func reminders() -> Single<[Reminder]> {
        Single<[Reminder]>.create { single in
            let reminders: [Reminder] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.remindersKey) else { return [] }
                
                let array = try? JSONDecoder().decode([Reminder].self, from: data)
                return array ?? []
            }()
            
            single(.success(reminders))
            
            return Disposables.create()
        }
    }
    
    func add(reminder: Reminder) -> Single<Reminder> {
        reminders()
            .flatMap { reminders -> Single<Reminder> in
                Single<Reminder>.create { single in
                    var result = reminders
                    result.append(reminder)
                    
                    if let data = try? JSONEncoder().encode(result) {
                        UserDefaults.standard.set(data, forKey: Constants.remindersKey)
                    }
                    
                    single(.success(reminder))
                    
                    RemindersMediator.shared.add(reminder: reminder)
                    
                    return Disposables.create()
                }
            }
    }
    
    func change(reminder new: Reminder) -> Single<Reminder?> {
        reminders()
            .flatMap { reminders -> Single<Reminder?> in
                Single<Reminder?>.create { single in
                    var result = reminders
                    
                    var reminder: Reminder?
                    
                    if let index = result.firstIndex(where: { $0.id == new.id }) {
                        reminder = new
                        result[index] = new
                    }
                    
                    if let data = try? JSONEncoder().encode(result) {
                        UserDefaults.standard.set(data, forKey: Constants.remindersKey)
                    }
                    
                    single(.success(reminder))
                    
                    if let reminder {
                        RemindersMediator.shared.edit(reminder: reminder)
                    }
                    
                    return Disposables.create()
                }
            }
    }
    
    func delete(id: String) -> Single<Void> {
        reminders()
            .flatMap { reminders -> Single<Void> in
                Single<Void>.create { single in
                    var result = reminders
                    
                    result.removeAll(where: { $0.id == id })
                    
                    if let data = try? JSONEncoder().encode(result) {
                        UserDefaults.standard.set(data, forKey: Constants.remindersKey)
                    }
                    
                    single(.success(Void()))
                    
                    RemindersMediator.shared.delete(id: id)
                    
                    return Disposables.create()
                }
            }
    }
}
