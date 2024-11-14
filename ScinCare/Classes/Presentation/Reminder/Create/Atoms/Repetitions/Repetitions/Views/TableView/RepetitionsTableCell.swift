//
//  RepetitionsTableCell.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 12.11.2024.
//

import UIKit

final class RepetitionsTableCell: UITableViewCell {
    lazy var label = makeLabel()
    lazy var checkedView = makeCheckedView()
    
    private lazy var sAttrs = TextAttributes()
        .textColor(Appearance.main100)
        .font(Fonts.Roboto.regular(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    private lazy var dAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.regular(size: 16.scale))
        .lineHeight(24.scale)
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
extension RepetitionsTableCell {
    func setup(element: RepetitionsTableElement) {
        let attrs = element.marked ? sAttrs : dAttrs
        label.attributedText = element.localizedTitle.attributed(with: attrs)
        
        checkedView.isHidden = !element.marked
    }
}

// MARK: Private
private extension RepetitionsTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension RepetitionsTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            checkedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RepetitionsTableCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CreateReminder.Checked")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
