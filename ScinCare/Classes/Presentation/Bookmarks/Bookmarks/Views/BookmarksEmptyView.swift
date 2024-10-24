//
//  BookmarksEmptyView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

import UIKit

final class BookmarksEmptyView: UIView {
    enum Unit {
        case procedures, diseases, glossaries
    }
    
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeLabel()
    lazy var textLabel = makeLabel()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.bold(size: 22.scale))
        .lineHeight(30.scale)
        .textAlignment(.center)
    private lazy var textAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.Roboto.regular(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension BookmarksEmptyView {
    func setup(unit: Unit) {
        switch unit {
        case .procedures:
            imageView.image = UIImage(named: "Bookmark.Empty.Procedures")
            titleLabel.attributedText = "Bookmarks.Empty.Procedures.Title".localized.attributed(with: titleAttrs)
            textLabel.attributedText = "Bookmarks.Empty.Procedures.SubTitle".localized.attributed(with: textAttrs)
        case .diseases:
            imageView.image = UIImage(named: "Bookmark.Empty.Diseases")
            titleLabel.attributedText = "Bookmarks.Empty.Disease.Title".localized.attributed(with: titleAttrs)
            textLabel.attributedText = "Bookmarks.Empty.Disease.SubTitle".localized.attributed(with: textAttrs)
        case .glossaries:
            imageView.image = UIImage(named: "Bookmark.Empty.Glossaries")
            titleLabel.attributedText = "Bookmarks.Empty.Glossary.Title".localized.attributed(with: titleAttrs)
            textLabel.attributedText = "Bookmarks.Empty.Glossary.SubTitle".localized.attributed(with: textAttrs)
        }
    }
}

// MARK: Make constraints
private extension BookmarksEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 140.scale),
            imageView.heightAnchor.constraint(equalToConstant: 140.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 164.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BookmarksEmptyView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
