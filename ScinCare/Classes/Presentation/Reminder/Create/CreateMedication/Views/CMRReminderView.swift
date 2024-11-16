//
//  CMRReminderView.swift
//  ScinCare
//
//  Created by Vitaliy Zagorodnov on 15.11.2024.
//

import UIKit
import RxCocoa
import RxSwift

class CMRReminderView: UIView {
    
    lazy var datePicker = makeDatePicker()
    lazy var countButton = makeCountButton()
    private lazy var label = makeLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CMRReminderView {
    var setup: Binder<Repetition> {
        Binder(self) { base, repetition in
            switch repetition {
            case .everyDay(let date):
                base.datePicker.date = date
                base.datePicker.datePickerMode = .time
                base.datePicker.isHidden = false
                base.countButton.isHidden = true
            case .everyMonth(let date):
                base.datePicker.date = date
                base.datePicker.datePickerMode = .dateAndTime
                base.datePicker.isHidden = false
                base.countButton.isHidden = true
            case .everyYear(let date):
                base.datePicker.date = date
                base.datePicker.datePickerMode = .dateAndTime
                base.datePicker.isHidden = false
                base.countButton.isHidden = true
            case .onSpecificDate(let date):
                base.datePicker.date = date
                base.datePicker.datePickerMode = .dateAndTime
                base.datePicker.isHidden = false
                base.countButton.isHidden = true
            case .everyMinutes(let int):
                base.datePicker.isHidden = true
                base.countButton.isHidden = false
                let attrs = TextAttributes()
                    .font(.systemFont(ofSize: 17.scale))
                    .textColor(Appearance.mono200)
                let text = String(format: "CreteMedication.EveryMinutes".localized, int)
                base.countButton.setAttributedTitle(text.attributed(with: attrs), for: .normal)
            case .everyHours(let int):
                base.datePicker.isHidden = true
                base.countButton.isHidden = false
                let attrs = TextAttributes()
                    .font(.systemFont(ofSize: 17.scale))
                    .textColor(Appearance.mono200)
                let text = String(format: "CreteMedication.EveryHours".localized, int)
                base.countButton.setAttributedTitle(text.attributed(with: attrs), for: .normal)
            case .everyDays(let int):
                base.datePicker.isHidden = true
                base.countButton.isHidden = false
                let attrs = TextAttributes()
                    .font(.systemFont(ofSize: 17.scale))
                    .textColor(Appearance.mono200)
                let text = String(format: "CreteMedication.EveryDays".localized, int)
                base.countButton.setAttributedTitle(text.attributed(with: attrs), for: .normal)
            }
        }
    }
}

// MARK: Private
private extension CMRReminderView {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 4.scale
        layer.masksToBounds = true
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main900.cgColor
    }
}

// MARK: Make constraints
private extension CMRReminderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            datePicker.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            countButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            countButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CMRReminderView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Roboto.regular(size: 16.scale))
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .lineHeight(19.scale)
            .textAlignment(.left)
        let view = UILabel()
        view.attributedText = "CreteMedication.Reminder".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDatePicker() -> UIDatePicker {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .compact
        view.tintColor = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCountButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
