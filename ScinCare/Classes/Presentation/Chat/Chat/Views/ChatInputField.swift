//
//  ChatInputField.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import UIKit

final class ChatInputField: UIView {
    lazy var textField = makeTextField()
    lazy var sendButton = makeSendButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextFieldDelegate
extension ChatInputField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension ChatInputField {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 27.scale
        layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.scale
    }
}

// MARK: Make constraints
private extension ChatInputField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sendButton.widthAnchor.constraint(equalToConstant: 24.scale),
            sendButton.heightAnchor.constraint(equalToConstant: 24.scale),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22.scale),
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ChatInputField {
    func makeTextField() -> PaddingTextField {
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Roboto.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.left)
        let textAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.left)
        
        let view = PaddingTextField()
        view.textPadding = UIEdgeInsets(t: 17.5.scale, l: 22.scale, b: 17.5.scale, r: 50.scale)
        view.defaultTextAttributes = textAttrs.dictionary
        view.attributedPlaceholder = "Chat.Input.Placeholder".localized.attributed(with: placeholderAttrs)
        view.delegate = self
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSendButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Chat.Input"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
