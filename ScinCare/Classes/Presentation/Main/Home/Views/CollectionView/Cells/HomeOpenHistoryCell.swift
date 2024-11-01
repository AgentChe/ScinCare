//
//  HomeOpenHistoryCell.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit

final class HomeOpenHistoryCell: UICollectionViewCell {
    var didOpenHistory: (() -> Void)?
    
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var placeholderView = makePlaceholderView()
    lazy var openHistoryButton = makeOpenHistoryButton()
    
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
private extension HomeOpenHistoryCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func openHistoryTapped() {
        didOpenHistory?()
    }
}

// MARK: Make constraints
private extension HomeOpenHistoryCell {
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
            placeholderView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            openHistoryButton.widthAnchor.constraint(equalToConstant: 131.scale),
            openHistoryButton.heightAnchor.constraint(equalToConstant: 54.scale),
            openHistoryButton.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -16.scale),
            openHistoryButton.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeOpenHistoryCell {
    func makeBackgroundImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16.scale
        view.image = UIImage(named: "Home.OpenHistory.Background")
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
        view.attributedText = "Home.OpenHistory.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 14.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = "Home.OpenHistory.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePlaceholderView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Home.OpenHistory.Placeholder")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeOpenHistoryButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Roboto.medium(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Home.OpenScanner.Button".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.main300
        view.addTarget(self, action: #selector(openHistoryTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
