//
//  ReminderCalendarDayCell.swift
//  ScinCare
//
//  Created by Vitaliy Zagorodnov on 17.11.2024.
//

import UIKit
import JTAppleCalendar

class ReminderCalendarDayCell: JTACDayCell {
    
    private lazy var weekDayLabel = makeLabel()
    private lazy var dayLabel = makeLabel()
    private lazy var statusView = makeStatusView()
    private lazy var daySelectView = makeDaySelectView()
    
    private lazy var statusViewWidth = NSLayoutConstraint()
    
    private lazy var dayAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.regular(size: 14.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.center)
    
    private lazy var weekDayAttrs = TextAttributes()
        .font(Fonts.Roboto.regular(size: 12.scale))
        .lineHeight(16.scale)
        .textAlignment(.center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ReminderCalendarDayCell {
    func setup(isSelected: Bool) {
        daySelectView.layer.borderWidth = isSelected ? 2.scale : 0
        daySelectView.layer.borderColor = isSelected ? Appearance.main100.cgColor : UIColor.clear.cgColor
        statusView.backgroundColor = isSelected ? Appearance.main100 : Appearance.main300
        weekDayLabel.textColor = isSelected ? Appearance.main100 : Appearance.mono200
    }
    
    func setup(isCurrentDay: Bool, isAvailableEvent: Bool, text: String, weekDay: DaysOfWeek) {
        dayLabel.attributedText = text.attributed(with: dayAttrs)
        weekDayLabel.attributedText = weekDay.dayName.attributed(with: weekDayAttrs)
        statusView.isHidden = !isAvailableEvent
        daySelectView.backgroundColor = isCurrentDay
            ? Appearance.mono100
            : UIColor.clear
        
        weekDayLabel.textColor = isCurrentDay
            ? Appearance.main100
            : Appearance.mono200.withAlphaComponent(0.7)
    }
}

// MARK: Make constraints
private extension ReminderCalendarDayCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            weekDayLabel.topAnchor.constraint(equalTo: topAnchor),
            weekDayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            weekDayLabel.heightAnchor.constraint(equalToConstant: 37.scale)
        ])
        
        NSLayoutConstraint.activate([
            daySelectView.widthAnchor.constraint(equalToConstant: 40.scale),
            daySelectView.heightAnchor.constraint(equalToConstant: 40.scale),
            daySelectView.centerXAnchor.constraint(equalTo: dayLabel.centerXAnchor),
            daySelectView.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayLabel.widthAnchor.constraint(equalToConstant: 40.scale),
            dayLabel.heightAnchor.constraint(equalToConstant: 40.scale),
            dayLabel.topAnchor.constraint(equalTo: weekDayLabel.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            statusView.widthAnchor.constraint(equalToConstant: 6.scale),
            statusView.heightAnchor.constraint(equalToConstant: 6.scale),
            statusView.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusView.bottomAnchor.constraint(equalTo: bottomAnchor),
            statusView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ReminderCalendarDayCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDaySelectView() -> CircleView {
        let view = CircleView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStatusView() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 3.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
}

class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = max(frame.width, frame.height) / 2
    }
}

private extension JTAppleCalendar.DaysOfWeek {
    var dayName: String {
        switch self {
        case .sunday:
            return "Reminders.DaysOfWeek.Su".localized
        case .monday:
            return "Reminders.DaysOfWeek.Mo".localized
        case .tuesday:
            return "Reminders.DaysOfWeek.Tu".localized
        case .wednesday:
            return "Reminders.DaysOfWeek.We".localized
        case .thursday:
            return "Reminders.DaysOfWeek.Th".localized
        case .friday:
            return "Reminders.DaysOfWeek.Fr".localized
        case .saturday:
            return "Reminders.DaysOfWeek.Sa".localized
        }
    }
}

