//
//  CRNameField.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 11.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CRNameField: UIView {
    enum Event {
        case medication
        case skinRescan
    }
    
    let event: Event
    
    lazy var textField = makeTextField()
    
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

// MARK: Public
extension CRNameField {
    var text: Signal<String> {
        textField.rx.text
            .map { $0 ?? "" }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: UITextFieldDelegate
extension CRNameField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension CRNameField {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 4.scale
        layer.masksToBounds = true
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main900.cgColor
    }
}

// MARK: Make constraints
private extension CRNameField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CRNameField {
    func makeTextField() -> PaddingTextField {
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Roboto.regular(size: 16.scale))
            .textAlignment(.left)
        let textAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 16.scale))
            .textAlignment(.left)
        
        let view = PaddingTextField()
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.attributedPlaceholder = event.placehodler.localized.attributed(with: placeholderAttrs)
        view.defaultTextAttributes = textAttrs.dictionary
        view.textPadding = UIEdgeInsets(vertical: 10.scale, horizontal: 8.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension CRNameField.Event {
    var placehodler: String {
        switch self {
        case .medication:
            return "CreateReminder.Medication.Name.Placeholder"
        case .skinRescan:
            return "CreateReminder.SkinRescan.Name.Placeholder"
        }
    }
}
