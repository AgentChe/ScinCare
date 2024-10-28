//
//  ChatView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import UIKit

final class ChatView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var historyButton = makeHistoryButton()
    lazy var placeholderView = makePlaceholderView()
    lazy var inputField = makeInputField()
    
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
private extension ChatView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension ChatView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            historyButton.widthAnchor.constraint(equalToConstant: 24.scale),
            historyButton.heightAnchor.constraint(equalToConstant: 24.scale),
            historyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            historyButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            placeholderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            placeholderView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            inputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            inputField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            inputField.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChatView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 22.scale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Chat.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHistoryButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Chat.History"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlaceholderView() -> ChatPlaceholderView {
        let view = ChatPlaceholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInputField() -> ChatInputField {
        let view = ChatInputField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
