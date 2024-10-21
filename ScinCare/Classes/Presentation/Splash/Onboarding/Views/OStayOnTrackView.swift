//
//  OStayOnTrackView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 21.10.2024.
//

import UIKit

final class OStayOnTrackView: OnboardingSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var textLabel = makeTextLabel()
    lazy var imageView = makeImageView()
    lazy var continueButton = makeContinueButton()
    lazy var skipButton = makeSkipButton()
    lazy var readMoreLabel = makeReadMoreLabel()
    
    init() {
        super.init(slide: .stayOnTrack)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OStayOnTrackView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension OStayOnTrackView {
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
            imageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            skipButton.heightAnchor.constraint(equalToConstant: 54.scale),
            skipButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            readMoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            readMoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            readMoreLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OStayOnTrackView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.StayOnTrack.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 18.scale))
            .lineHeight(21.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.StayOnTrack.Text".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.StayOnTrack")
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
    
    func makeSkipButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Skip".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.main900
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onSkip), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeReadMoreLabel() -> UILabel {
        let bAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Roboto.bold(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        let rAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Roboto.regular(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        let underlineAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Roboto.regular(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
            .underlineColor(Appearance.mono200.withAlphaComponent(0.23))
            .underlineStyle(.single)
        
        let result = NSMutableAttributedString()
        result.append("Onboarding.BottomInfo1".localized.attributed(with: rAttrs))
        result.append("Onboarding.BottomInfo2".localized.attributed(with: bAttrs))
        result.append("Onboarding.BottomInfo3".localized.attributed(with: rAttrs))
        result.append("Onboarding.BottomInfo4".localized.attributed(with: underlineAttrs))
        
        let view = UILabel()
        view.attributedText = result
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onReadMore))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
}
