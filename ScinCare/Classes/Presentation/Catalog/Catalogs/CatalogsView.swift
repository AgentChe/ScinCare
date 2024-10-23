//
//  CatalogsView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import UIKit

final class CatalogsView: UIView {
    lazy var backButton = makeBackButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var searchField = makeSearchField()
    lazy var tableView = makeTableView()
    
    private let title: String
    
    init(item: CatalogsViewController.Item) {
        self.title = item.title
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CatalogsView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension CatalogsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24.scale),
            backButton.heightAnchor.constraint(equalToConstant: 24.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 6.scale),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            searchField.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CatalogsView {
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Back"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 22.scale))
            .lineHeight(30.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSearchField() -> CatalogsSearchField {
        let view = CatalogsSearchField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> CatalogsTableView {
        let view = CatalogsTableView()
        view.contentInset = UIEdgeInsets(vertical: 10.scale)
        view.setContentOffset(CGPoint(x: 0, y: -10.scale), animated: false)
        view.separatorStyle = .singleLine
        view.separatorColor = Appearance.main900
        view.separatorInset = UIEdgeInsets(horizontal: 16.scale)
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension CatalogsViewController.Item {
    var title: String {
        switch self {
        case .glossary:
            return "Catalogs.Glossaries.Title".localized
        case .procedure:
            return "Catalogs.Procedures.Title".localized
        case .disease:
            return "Catalogs.Diseases.Title".localized
        }
    }
}
