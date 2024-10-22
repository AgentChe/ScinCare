//
//  HomeExploreItemButton.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import UIKit

final class HomeExploreItemButton: UIButton {
    enum Item {
        case procedures
        case disease
        case glossary
    }
    
    lazy var iconView = makeIconView()
    lazy var headerLabel = makeHeaderLabel()
    lazy var textLabel = makeTextLabel()
    
    let item: Item
    
    init(item: Item) {
        self.item = item
        
        super.init(frame: .zero)
        
        makeConstrainst()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension HomeExploreItemButton {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 16.scale
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main900.cgColor
    }
}

// MARK: Make constraints
private extension HomeExploreItemButton {
    func makeConstrainst() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 48.scale),
            iconView.heightAnchor.constraint(equalToConstant: 48.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            headerLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeExploreItemButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: item.iconName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHeaderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.medium(size: 18.scale))
            .lineHeight(21.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = item.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Roboto.regular(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = item.text.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension HomeExploreItemButton.Item {
    var iconName: String {
        switch self {
        case .procedures:
            return "Home.Explore.Procedures"
        case .disease:
            return "Home.Explore.Disease"
        case .glossary:
            return "Home.Explore.Glossary"
        }
    }
    
    var title: String {
        switch self {
        case .procedures:
            return "Home.Explore.Procedures.Title".localized
        case .disease:
            return "Home.Explore.Disease.Title".localized
        case .glossary:
            return "Home.Explore.Glossary.Title".localized
        }
    }
    
    var text: String {
        switch self {
        case .procedures:
            return "Home.Explore.Procedures.Text".localized
        case .disease:
            return "Home.Explore.Disease.Text".localized
        case .glossary:
            return "Home.Explore.Glossary.Text".localized
        }
    }
}
