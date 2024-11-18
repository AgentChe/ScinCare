//
//  HomeAddReminderCell.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 18.11.2024.
//

import UIKit

final class HomeAddReminderCell: UICollectionViewCell {
    var didAddReminder: (() -> Void)?
    
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var placeholderView = makePlaceholderView()
    lazy var addReminderButton = makeAddReminderButton()
    
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
private extension HomeAddReminderCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func addReminderTapped() {
        didAddReminder?()
    }
}

// MARK: Make constraints
private extension HomeAddReminderCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 194.scale),
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.scale)
        ])
        
        NSLayoutConstraint.activate([
            placeholderView.widthAnchor.constraint(equalToConstant: 112.scale),
            placeholderView.heightAnchor.constraint(equalToConstant: 112.scale),
            placeholderView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addReminderButton.widthAnchor.constraint(equalToConstant: 105.scale),
            addReminderButton.heightAnchor.constraint(equalToConstant: 54.scale),
            addReminderButton.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16.scale),
            addReminderButton.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeAddReminderCell {
    func makeBackgroundImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16.scale
        view.image = UIImage(named: "Home.AddReminder.Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 14.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = "Home.AddReminder.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 22.scale))
            .lineHeight(30.scale)
        
        let view = UILabel()
        view.attributedText = "Home.AddReminder.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePlaceholderView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Home.AddReminder.Placeholder")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeAddReminderButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Roboto.medium(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Home.AddReminder.Button".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(addReminderTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
