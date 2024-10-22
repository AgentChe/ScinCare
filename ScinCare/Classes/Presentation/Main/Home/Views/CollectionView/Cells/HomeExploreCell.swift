//
//  HomeExploreCell.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 21.10.2024.
//

import UIKit

final class HomeExploreCell: UICollectionViewCell {
    var didTap: ((HomeExploreItemButton.Item) -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var proceduresButton = makeItemButton(item: .procedures)
    lazy var diseaseButton = makeItemButton(item: .disease)
    lazy var glossaryButton = makeItemButton(item: .glossary)
    
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
private extension HomeExploreCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func tapped(sender: UIButton) {
        guard let itemButton = sender as? HomeExploreItemButton else { return }
        
        didTap?(itemButton.item)
    }
}

// MARK: Make constraints
private extension HomeExploreCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            proceduresButton.widthAnchor.constraint(equalToConstant: 164.scale),
            proceduresButton.heightAnchor.constraint(equalToConstant: 175.scale),
            proceduresButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            proceduresButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            diseaseButton.widthAnchor.constraint(equalToConstant: 164.scale),
            diseaseButton.heightAnchor.constraint(equalToConstant: 175.scale),
            diseaseButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 195.scale),
            diseaseButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            glossaryButton.widthAnchor.constraint(equalToConstant: 164.scale),
            glossaryButton.heightAnchor.constraint(equalToConstant: 175.scale),
            glossaryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            glossaryButton.topAnchor.constraint(equalTo: proceduresButton.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeExploreCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 22.scale))
            .lineHeight(30.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Home.Explore.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeItemButton(item: HomeExploreItemButton.Item) -> HomeExploreItemButton {
        let view = HomeExploreItemButton(item: item)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
