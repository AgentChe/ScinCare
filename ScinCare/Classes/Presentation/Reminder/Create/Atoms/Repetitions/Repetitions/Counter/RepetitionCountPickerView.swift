//
//  RepetitionCountPickerView.swift
//  ScinCare
//
//  Created by Vitaliy Zagorodnov on 14.11.2024.
//

import UIKit

final class RepetitionCountPickerView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var pickerView = makePickerView()
    lazy var leftLabel = makeLabelView()
    lazy var rightLabel = makeLabelView()
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
extension RepetitionCountPickerView {
    func setup(type: RepetitionCountType) {
        let titleAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 22.scale))
            .lineHeight(30.scale)
            .textAlignment(.center)
        
        let labelAttrs = TextAttributes()
            .font(Fonts.Roboto.regular(size: 16.scale))
            .lineHeight(19.scale)
        
        titleLabel.attributedText = type.title.attributed(with: titleAttrs)
        leftLabel.attributedText = "Repetitions.Every".localized.attributed(with: labelAttrs)
        rightLabel.attributedText = type.right.attributed(with: labelAttrs)
    }
}

// MARK: Private
private extension RepetitionCountPickerView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension RepetitionCountPickerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 42.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale),
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.widthAnchor.constraint(equalToConstant: 78.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftLabel.trailingAnchor.constraint(equalTo: pickerView.leadingAnchor, constant: -20.scale),
            leftLabel.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightLabel.leadingAnchor.constraint(equalTo: pickerView.trailingAnchor, constant: 20.scale),
            rightLabel.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(greaterThanOrEqualTo: pickerView.bottomAnchor, constant: 64.scale),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            confirmButton.heightAnchor.constraint(equalToConstant: 54.scale),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RepetitionCountPickerView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePickerView() -> UIPickerView {
        let view = UIPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabelView() -> UILabel {
        let view = UILabel()
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
