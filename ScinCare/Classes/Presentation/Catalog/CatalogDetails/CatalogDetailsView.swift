//
//  CatalogDetailsView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

import UIKit

final class CatalogDetailsView: UIView {
    lazy var backButton = makeBackButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var bookmarkButton = makeBookmarkButton()
    lazy var tableView = makeTableView()
    lazy var preloader = makePreloader()
    
    private let title: String
    
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CatalogDetailsView {
    func update(marked: Bool) {
        let image = UIImage(named: marked ? "CatalogDetails.Saved" : "CatalogDetails.Unsaved")
        bookmarkButton.setImage(image, for: .normal)
    }
}

// MARK: Private
private extension CatalogDetailsView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension CatalogDetailsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24.scale),
            backButton.heightAnchor.constraint(equalToConstant: 24.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bookmarkButton.widthAnchor.constraint(equalToConstant: 24.scale),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 24.scale),
            bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            bookmarkButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CatalogDetailsView {
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Back.Black"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 16.scale))
            .lineHeight(30.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBookmarkButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> CDTableView {
        let view = CDTableView()
        view.contentInset = UIEdgeInsets(vertical: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.color = Appearance.main100
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
