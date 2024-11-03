//
//  SASTScannedAreaView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 03.11.2024.
//

import UIKit

final class SASTScannedAreaView: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.regular(size: 16.scale))
        .lineHeight(19.scale)
        .textAlignment(.left)
    
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
extension SASTScannedAreaView {
    func setup(side: Side, area: SkinArea) {
        imageView.setup(side: side, area: area)
        
        let joined = [side.localized, area.localized]
            .joined(separator: ", ")
        let value = String(format: "SaveAnalyseSetTitle.ScannedArea".localized, joined)
        label.attributedText = value.attributed(with: attrs)
    }
}

// MARK: Private
private extension SASTScannedAreaView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension SASTScannedAreaView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 90.scale),
            imageView.heightAnchor.constraint(equalToConstant: 90.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SASTScannedAreaView {
    func makeImageView() -> SASTScannedAreaImageView {
        let view = SASTScannedAreaImageView()
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
