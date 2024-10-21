//
//  TabView.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 08.09.2024.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case home, favorites, scan, calendar, chat
    }
    
    lazy var container = makeContainer()
    lazy var homeButton = makeButton(imageDomain: "Main.Home")
    lazy var favoritesButton = makeButton(imageDomain: "Main.Favorites")
    lazy var scanButton = makeScanButton()
    lazy var calendarButton = makeButton(imageDomain: "Main.Calendar")
    lazy var chatButton = makeButton(imageDomain: "Main.Chat")
    
    var selectedTab = Tab.home {
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
        homeButton.marked = selectedTab == .home
        favoritesButton.marked = selectedTab == .favorites
        calendarButton.marked = selectedTab == .calendar
        chatButton.marked = selectedTab == .chat
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 14.scale),
            container.heightAnchor.constraint(equalToConstant: 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            homeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            homeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            homeButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            homeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            favoritesButton.widthAnchor.constraint(equalToConstant: 24.scale),
            favoritesButton.heightAnchor.constraint(equalToConstant: 24.scale),
            favoritesButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            favoritesButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 83.scale)
        ])
        
        NSLayoutConstraint.activate([
            scanButton.widthAnchor.constraint(equalToConstant: 68.scale),
            scanButton.heightAnchor.constraint(equalToConstant: 68.scale),
            scanButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            scanButton.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            calendarButton.widthAnchor.constraint(equalToConstant: 24.scale),
            calendarButton.heightAnchor.constraint(equalToConstant: 24.scale),
            calendarButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            calendarButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 235.scale)
        ])
        
        NSLayoutConstraint.activate([
            chatButton.widthAnchor.constraint(equalToConstant: 24.scale),
            chatButton.heightAnchor.constraint(equalToConstant: 24.scale),
            chatButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            chatButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 289.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 35.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScanButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Main.Scan"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton(imageDomain: String) -> TabItemButton {
        let view = TabItemButton(imageDomain: imageDomain)
        view.dx = -15.scale
        view.dy = -15.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
