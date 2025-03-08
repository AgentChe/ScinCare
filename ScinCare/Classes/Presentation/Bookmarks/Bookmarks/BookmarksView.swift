//
//  BookmarksView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

import UIKit

final class BookmarksView: UIView {
    lazy var navigationsActionsContainer = makeNavigationActionsContainer()
    lazy var editButton = makeNavigationButton(iconName: "Bookmark.Edit")
    lazy var doneButton = makeNavigationButton(iconName: "Bookmark.Done")
    lazy var deleteButton = makeNavigationButton(iconName: "Bookmark.Delete")
    lazy var titleLabel = makeTitleLabel()
    lazy var filterView = makeFilterView()
    lazy var tableView = makeTableView()
    lazy var emptyView = makeEmptyView()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension BookmarksView {
    func navigationMode(_ navigationMode: BookmarksViewController.NavigationMode) {
        editButton.isHidden = navigationMode == .editable
        doneButton.isHidden = navigationMode == .normal
        deleteButton.isHidden = navigationMode == .normal
    }
}

// MARK: Private
private extension BookmarksView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension BookmarksView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationsActionsContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            navigationsActionsContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            navigationsActionsContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale),
            navigationsActionsContainer.heightAnchor.constraint(equalToConstant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            editButton.widthAnchor.constraint(equalToConstant: 24.scale),
            editButton.heightAnchor.constraint(equalToConstant: 24.scale),
            editButton.leadingAnchor.constraint(equalTo: navigationsActionsContainer.leadingAnchor),
            editButton.centerYAnchor.constraint(equalTo: navigationsActionsContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            doneButton.widthAnchor.constraint(equalToConstant: 24.scale),
            doneButton.heightAnchor.constraint(equalToConstant: 24.scale),
            doneButton.leadingAnchor.constraint(equalTo: navigationsActionsContainer.leadingAnchor),
            doneButton.centerYAnchor.constraint(equalTo: navigationsActionsContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 24.scale),
            deleteButton.heightAnchor.constraint(equalToConstant: 24.scale),
            deleteButton.trailingAnchor.constraint(equalTo: navigationsActionsContainer.trailingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: navigationsActionsContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: editButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 28.scale),
            filterView.heightAnchor.constraint(equalToConstant: 35.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: filterView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            emptyView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BookmarksView {
    func makeNavigationActionsContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNavigationButton(iconName: String) -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: iconName), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        navigationsActionsContainer.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 22.scale))
            .lineHeight(30.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Bookmarks.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFilterView() -> BookmarksFilterView {
        let view = BookmarksFilterView()
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets.zero
        view.contentOffset = CGPoint.zero
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> BookmarksTableView {
        let view = BookmarksTableView()
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
    
    func makeEmptyView() -> BookmarksEmptyView {
        let view = BookmarksEmptyView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
