//
//  CMRNoteView.swift
//  ScinCare
//
//  Created by Vitaliy Zagorodnov on 15.11.2024.
//

import UIKit

class CMRNoteView: UIView {
    
    lazy var textField = makeNoteField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CMRNoteView {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 4.scale
        layer.masksToBounds = true
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main900.cgColor
    }
}

// MARK: Make constraints
private extension CMRNoteView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

private extension CMRNoteView {
    func makeNoteField() -> UITextField {
        let view = UITextField()
        let label = UILabel()
        let attrs = TextAttributes()
            .font(Fonts.Roboto.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
        label.attributedText = "CreteMedication.Optional".localized.attributed(with: attrs)
        view.rightView = label
        view.rightViewMode = .unlessEditing
        view.attributedPlaceholder = "CreteMedication.Note".localized.attributed(with: attrs)
        view.backgroundColor = Appearance.mono100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
