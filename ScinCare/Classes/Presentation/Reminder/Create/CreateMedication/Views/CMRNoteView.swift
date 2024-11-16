//
//  CMRNoteView.swift
//  ScinCare
//
//  Created by Vitaliy Zagorodnov on 15.11.2024.
//

import UIKit

final class CMRNoteView: UIView {
    enum Event {
        case medication
        case skinRescan
    }
    
    let event: Event
    
    lazy var textField = makeNoteField()

    init(event: Event) {
        self.event = event
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CMRNoteView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        view.attributedPlaceholder = event.key.localized.attributed(with: attrs)
        view.backgroundColor = Appearance.mono100
        view.returnKeyType = .done
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension CMRNoteView.Event {
    var key: String {
        switch self {
        case .medication:
            return "CreteMedication.AddNote"
        case .skinRescan:
            return "CreteMedication.Note"
        }
    }
}
