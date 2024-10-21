//
//  ODisclaimerView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 21.10.2024.
//

import UIKit

final class ODisclaimerView: OnboardingSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var textLabel = makeTextLabel()
    lazy var imageView = makeImageView()
    lazy var continueButton = makeContinueButton()
    
    init() {
        super.init(slide: .disclaimer)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ODisclaimerView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension ODisclaimerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 88.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 322.scale),
            imageView.heightAnchor.constraint(equalToConstant: 322.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ODisclaimerView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Disclaimer.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let bAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 18.scale))
            .lineHeight(21.scale)
            .textAlignment(.left)
        let rAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 18.scale))
            .lineHeight(21.scale)
            .textAlignment(.left)
        
        let result = NSMutableAttributedString()
        result.append("Onboarding.Disclaimer.Text1".localized.attributed(with: rAttrs))
        result.append("Onboarding.Disclaimer.Text2".localized.attributed(with: bAttrs))
        result.append("Onboarding.Disclaimer.Text3".localized.attributed(with: rAttrs))
        result.append("Onboarding.Disclaimer.Text4".localized.attributed(with: bAttrs))
        result.append("Onboarding.Disclaimer.Text5".localized.attributed(with: rAttrs))
        
        let view = UILabel()
        view.attributedText = result
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Disclaimer")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Roboto.bold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
