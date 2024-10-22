//
//  MenuRouteButton.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import UIKit

final class MenuRouteButton: UIButton {
    enum Route {
        case disclaimer, termsOfUse, privacyPolicy, support
    }
    
    lazy var label = makeLabel()
    lazy var separator = makeSeparator()
    
    private let route: Route
    
    init(route: Route) {
        self.route = route
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension MenuRouteButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension MenuRouteButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MenuRouteButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = route.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.isHidden = route.separatorHidden
        view.backgroundColor = Appearance.main900
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension MenuRouteButton.Route {
    var title: String {
        switch self {
        case .disclaimer:
            return "Menu.Disclaimer".localized
        case .termsOfUse:
            return "Menu.TermsOfUse".localized
        case .privacyPolicy:
            return "Menu.PrivacyPolicy".localized
        case .support:
            return "Menu.Support".localized
        }
    }
    
    var separatorHidden: Bool {
        switch self {
        case .support:
            return true
        case .disclaimer, .termsOfUse, .privacyPolicy:
            return false
        }
    }
}
