//
//  RemindersTableView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 11.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class RemindersTableView: UITableView {
    private lazy var elements = [RemindersTableElement]()
    
    private lazy var didTapAddEventTrigger = PublishRelay<Void>()
    private lazy var didSelectReminderTrigger = PublishRelay<Reminder>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RemindersTableView {
    func setup(elements: [RemindersTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapAddEvent: Signal<Void> {
        didTapAddEventTrigger.asSignal()
    }
    
    var didSelectReminder: Signal<Reminder> {
        didSelectReminderTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension RemindersTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .add:
            let cell = dequeueReusableCell(withIdentifier: String(describing: RemindersTableAddCell.self), for: indexPath) as! RemindersTableAddCell
            cell.didTapAdd = { [weak self] in
                self?.didTapAddEventTrigger.accept(Void())
            }
            return cell
        case .reminder(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RemindersTableCell.self), for: indexPath) as! RemindersTableCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension RemindersTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .reminder(let element):
            didSelectReminderTrigger.accept(element)
        default:
            return
        }
    }
}

// MARK: Private
private extension RemindersTableView {
    func initialize() {
        register(RemindersTableAddCell.self, forCellReuseIdentifier: String(describing: RemindersTableAddCell.self))
        register(RemindersTableCell.self, forCellReuseIdentifier: String(describing: RemindersTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
