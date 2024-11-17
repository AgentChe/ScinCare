//
//  RemindersTableCell.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 14.11.2024.
//

import UIKit

final class RemindersTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var iconView = makeIconView()
    lazy var stackView = makeStackView()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.main100)
        .font(Fonts.Roboto.bold(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.regular(size: 16.scale))
        .lineHeight(19.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var triggerAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.Roboto.regular(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
    private lazy var noteTitleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.bold(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
    private lazy var noteAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.regular(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
    
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale.current
        return formatter
    }()
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        formatter.locale = Locale.current
        return formatter
    }()
    private lazy var dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy at HH:mm"
        formatter.locale = Locale.current
        return formatter
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RemindersTableCell {
    func setup(element: Reminder) {
        let iconName: String = {
            switch element.event {
            case .medication:
                return "Reminders.R.Medication"
            case .skinRescan:
                return "Reminders.R.ScinRescan"
            }
        }()
        iconView.image = UIImage(named: iconName)
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        stackView.addArrangedSubview(makeTitleLabel(event: element.event))
        stackView.addArrangedSubview(makeNameLabel(name: element.name))
        stackView.addArrangedSubview(makeTriggerLabel(trigger: element.trigger))
        
        if let note = element.note {
            stackView.addArrangedSubview(makeNoteLabel(note: note))
        }
        
        layoutIfNeeded()
    }
}

// MARK: Private
private extension RemindersTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    func makeTitleLabel(event: Reminder.Event) -> UILabel {
        let title: String = {
            switch event {
            case .medication:
                return "Reminders.Medication.Title".localized
            case .skinRescan:
                return "Reminders.SkinRescan.Title".localized
            }
        }()
        
        let view = UILabel()
        view.attributedText = title.attributed(with: titleAttrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeNameLabel(name: String) -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.attributedText = name.attributed(with: nameAttrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeTriggerLabel(trigger: Repetition) -> UILabel {
        let triggerLocalized = {
            switch trigger {
            case .everyDay(let time):
                let time = timeFormatter.string(from: time)
                return String(format: "Reminders.Trigger.EveryDay".localized, time)
            case .everyMinutes(let minutes):
                return String(format: "Reminders.Trigger.EveryMinutes".localized, minutes)
            case .everyHours(let hours):
                return String(format: "Reminders.Trigger.EveryHours".localized, hours)
            case .everyDays(let days):
                return String(format: "Reminders.Trigger.EveryDays".localized, days)
            case .everyMonth(let day):
                let day = dayFormatter.string(from: day)
                return String(format: "Reminders.Trigger.EveryMonth".localized, day)
            case .everyYear(let day):
                let day = dayFormatter.string(from: day)
                return String(format: "Reminders.Trigger.EveryYear".localized, day)
            case .onSpecificDate(let date):
                return dateTimeFormatter.string(from: date)
            }
        }()
        
        let view = UILabel()
        view.attributedText = triggerLocalized.attributed(with: triggerAttrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeNoteLabel(note: String) -> UILabel {
        let result = NSMutableAttributedString()
        result.append("Reminders.NoteTitle".localized.attributed(with: noteTitleAttrs))
        result.append(note.attributed(with: noteAttrs))
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = result
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

// MARK: Make constraints
private extension RemindersTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 80.scale),
            iconView.heightAnchor.constraint(equalToConstant: 80.scale),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 112.scale),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RemindersTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 10.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 40.scale
        view.layer.masksToBounds = true
        view.image = UIImage(named: "Reminders.R.Medication")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.backgroundColor = UIColor.clear
        view.axis = .vertical
        view.spacing = 5.scale
        view.distribution = .fill
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
