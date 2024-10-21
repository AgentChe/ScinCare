//
//  TabView.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 08.09.2024.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case recognizer, assistant, account
    }
    
    lazy var recognizerButton = makeRecognizerButton()
    lazy var assistantButton = makeButton(code: "Main.Assistant")
    lazy var accountButton = makeButton(code: "Main.Account")
    
    var selectedTab = Tab.assistant {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabView {
    func update() {
        assistantButton.marked = selectedTab == .assistant
        accountButton.marked = selectedTab == .account
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            recognizerButton.widthAnchor.constraint(equalToConstant: 75.scale),
            recognizerButton.heightAnchor.constraint(equalToConstant: 80.scale),
            recognizerButton.topAnchor.constraint(equalTo: topAnchor),
            recognizerButton.trailingAnchor.constraint(equalTo: assistantButton.leadingAnchor, constant: -19.scale)
        ])
        
        NSLayoutConstraint.activate([
            assistantButton.widthAnchor.constraint(equalToConstant: 75.scale),
            assistantButton.heightAnchor.constraint(equalToConstant: 80.scale),
            assistantButton.topAnchor.constraint(equalTo: topAnchor),
            assistantButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            accountButton.widthAnchor.constraint(equalToConstant: 75.scale),
            accountButton.heightAnchor.constraint(equalToConstant: 80.scale),
            accountButton.leadingAnchor.constraint(equalTo: assistantButton.trailingAnchor, constant: 19.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeRecognizerButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Main.Recognize"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton(code: String) -> TabItemView {
        let view = TabItemView(code: code)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
