//
//  RemindersCalendarView.swift
//  ScinCare
//
//  Created by Vitaliy Zagorodnov on 17.11.2024.
//

import UIKit
import JTAppleCalendar

class RemindersCalendarView: JTACMonthView {
    private var didSelectDate: ((Date) -> Void)?
    private var elements = [Reminder]()

    override init() {
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RemindersCalendarView {
    func setup(elements: [Reminder], didSelectDate: @escaping (Date) -> Void) {
        self.elements = elements
        self.didSelectDate = didSelectDate
        reloadData()
    }
}

extension RemindersCalendarView: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let startDate = calendar.date(byAdding: .year, value: -2, to: currentDate) ?? currentDate
        let endDate = calendar.date(byAdding: .year, value: 2, to: currentDate) ?? currentDate
        
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: 1,
            firstDayOfWeek: .sunday
        )
    }
}

extension RemindersCalendarView: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: String(describing: ReminderCalendarDayCell.self), for: indexPath) as! ReminderCalendarDayCell
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? ReminderCalendarDayCell else { return }
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? ReminderCalendarDayCell else { return }
        cell.setup(isSelected: cellState.isSelected)
        didSelectDate?(date)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? ReminderCalendarDayCell else { return }
        cell.setup(isSelected: cellState.isSelected)
    }
}

private extension RemindersCalendarView {
    func initialize() {
        scrollDirection = .horizontal
        calendarDelegate = self
        calendarDataSource = self
        backgroundColor = .clear
        scrollingMode = .stopAtEachCalendarFrame
        showsHorizontalScrollIndicator = false
        register(ReminderCalendarDayCell.self, forCellWithReuseIdentifier: String(describing: ReminderCalendarDayCell.self))
        scrollToDate(.init(), animateScroll: false) { [weak self] in
            
            guard let self  else { return }
            
            self.selectDates([.init()])
            
            if let today = self.indexPathsForSelectedItems?.first {
                self.scrollToItem(at: today, at: .centeredVertically, animated: false)
            }
        }
    }
    
    func configureCell(cell: ReminderCalendarDayCell, cellState: CellState) {
        let calendar = Calendar.current
        let isCurrentDay = calendar.compare(cellState.date, to: Date(), toGranularity: .day) == .orderedSame
        cell.setup(
            isCurrentDay: isCurrentDay,
            isAvailableEvent: elements.contains { $0.isEvent(for: cellState.date) },
            text: cellState.text,
            weekDay: cellState.day
        )
        cell.setup(isSelected: cellState.isSelected)
    }
}
