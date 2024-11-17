//
//  RepetitionSpecificDayView.swift
//  ScinCare
//
//  Created by Vitaliy Zagorodnov on 15.11.2024.
//

import UIKit

final class RepetitionSpecificDayView: UIView {

    lazy var datePicker = makeDatePicker()
    lazy var confirmButton = makeConfirmButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RepetitionSpecificDayView {
    func setup(minDate: Date?, maxDate: Date?) {
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
}

// MARK: Private
private extension RepetitionSpecificDayView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension RepetitionSpecificDayView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(greaterThanOrEqualTo: datePicker.bottomAnchor, constant: 16.scale),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            confirmButton.heightAnchor.constraint(equalToConstant: 54.scale),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RepetitionSpecificDayView {
    func makeDatePicker() -> UIDatePicker {
        let view = UIDatePicker()
        view.datePickerMode = .dateAndTime
        view.preferredDatePickerStyle = .inline
        view.tintColor = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeConfirmButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Roboto.bold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Repetitions.SaveButton".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
