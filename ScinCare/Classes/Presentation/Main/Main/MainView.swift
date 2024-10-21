//
//  MainView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

import UIKit

final class MainView: UIView {
    lazy var container = makeContainer()
    lazy var tabView = makeTabView()
    
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
private extension MainView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension MainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: tabView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabView.heightAnchor.constraint(equalToConstant: 114.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MainView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTabView() -> TabView {
        let view = TabView()
        view.backgroundColor = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
