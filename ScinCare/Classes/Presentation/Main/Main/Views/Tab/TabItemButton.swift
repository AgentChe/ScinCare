//
//  TabItemButton.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 08.09.2024.
//

import UIKit

final class TabItemView: TapAreaButton {
    lazy var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    lazy var container = makeContainer()
    lazy var iconView = makeImageView()
    lazy var label = makeLabel()
    
    private let code: String
    
    init(code: String) {
        self.code = code
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabItemView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        let iconName = code + (marked ? ".S" : ".D")
        iconView.image = UIImage(named: iconName)
        
        label.alpha = marked ? 1 : 0.4
    }
}

// MARK: Make constraints
private extension TabItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 30.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabItemView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.medium(size: 12.scale))
            .lineHeight(15.scale)
            .textAlignment(.center)
            .letterSpacing(-0.24.scale)
        
        let view = UILabel()
        view.attributedText = code.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
