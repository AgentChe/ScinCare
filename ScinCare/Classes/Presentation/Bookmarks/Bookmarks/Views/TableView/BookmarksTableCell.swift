//
//  BookmarksTableCell.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

import UIKit

final class BookmarksTableCell: UITableViewCell {
    lazy var checkedView = makeCheckedView()
    lazy var nameLabel = makeLabel()
    lazy var arrowView = makeArrowView()
    
    private lazy var nameLeadingConstraint = NSLayoutConstraint()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.regular(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension BookmarksTableCell {
    func setup(element: BookmarksTableElement) {
        nameLabel.attributedText = element.catalog.name.attributed(with: attrs)
        
        checkedView.image = UIImage(named: element.selected == true ? "Bookmark.Checked" : "Bookmark.Unchecked")
        checkedView.isHidden = element.selected == nil
        
        nameLeadingConstraint.isActive = false
        nameLeadingConstraint.constant = element.selected == nil ? 16.scale : 48.scale
        nameLeadingConstraint.isActive = true
        
        layoutIfNeeded()
    }
}

// MARK: Private
private extension BookmarksTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension BookmarksTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            checkedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        nameLeadingConstraint = nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale)
        NSLayoutConstraint.activate([
            nameLeadingConstraint,
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 24.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 24.scale),
            arrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension BookmarksTableCell {
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Bookmark.Arrow.Right")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
