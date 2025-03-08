//
//  MenuView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import UIKit

final class MenuView: UIView {
    lazy var disclaimerButton = makeRouteButton(route: .disclaimer)
    lazy var termsOfUseButton = makeRouteButton(route: .termsOfUse)
    lazy var privacyPolicyButton = makeRouteButton(route: .privacyPolicy)
    lazy var supportButton = makeRouteButton(route: .support)
    
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
private extension MenuView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension MenuView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            disclaimerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            disclaimerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            disclaimerButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 46.scale),
            disclaimerButton.heightAnchor.constraint(equalToConstant: 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfUseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            termsOfUseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            termsOfUseButton.topAnchor.constraint(equalTo: disclaimerButton.bottomAnchor, constant: 24.scale),
            termsOfUseButton.heightAnchor.constraint(equalToConstant: 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            privacyPolicyButton.topAnchor.constraint(equalTo: termsOfUseButton.bottomAnchor, constant: 24.scale),
            privacyPolicyButton.heightAnchor.constraint(equalToConstant: 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            supportButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            supportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            supportButton.topAnchor.constraint(equalTo: privacyPolicyButton.bottomAnchor, constant: 24.scale),
            supportButton.heightAnchor.constraint(equalToConstant: 44.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MenuView {
    func makeRouteButton(route: MenuRouteButton.Route) -> MenuRouteButton {
        let view = MenuRouteButton(route: route)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
