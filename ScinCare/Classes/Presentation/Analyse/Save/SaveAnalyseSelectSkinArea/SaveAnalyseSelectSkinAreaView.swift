//
//  SaveAnalyseSelectSkinAreaView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 02.11.2024.
//

import UIKit

final class SaveAnalyseSelectSkinAreaView: UIView {
    lazy var backButton = makeBackButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var selectedSkinAreaLabel = makeLabel()
    lazy var leftSideButton = makeTapButton(iconName: "SelectSkinArea.LeftArrow")
    lazy var skinAreaView = makeSkinAreaView()
    lazy var rightSideButton = makeTapButton(iconName: "SelectSkinArea.RightArrow")
    lazy var continueButton = makeContinueButton()
    
    private lazy var selectedSkinAreaAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.regular(size: 16.scale))
        .lineHeight(19.scale)
        .textAlignment(.center)
    private lazy var continueButtonEnableAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Roboto.bold(size: 16.scale))
    private lazy var continueButtonDisableAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.Roboto.bold(size: 16.scale))
    
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
extension SaveAnalyseSelectSkinAreaView {
    func display(side: Side, area: SkinArea?) {
        let string = [side.localized, area?.localized]
            .compactMap { $0 }
            .joined(separator: ", ")
        selectedSkinAreaLabel.attributedText = string.attributed(with: selectedSkinAreaAttrs)
    }
    
    func continueButton(enable: Bool) {
        continueButton.isUserInteractionEnabled = enable
        
        continueButton.backgroundColor = enable ? Appearance.main100 : Appearance.main900
        
        let attrs = enable ? continueButtonEnableAttrs : continueButtonDisableAttrs
        continueButton.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
    }
}

// MARK: Private
private extension SaveAnalyseSelectSkinAreaView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make Constraints
private extension SaveAnalyseSelectSkinAreaView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24.scale),
            backButton.heightAnchor.constraint(equalToConstant: 24.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 6.scale),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            selectedSkinAreaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            selectedSkinAreaLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            selectedSkinAreaLabel.bottomAnchor.constraint(equalTo: skinAreaView.topAnchor, constant: -25.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftSideButton.widthAnchor.constraint(equalToConstant: 24.scale),
            leftSideButton.heightAnchor.constraint(equalToConstant: 24.scale),
            leftSideButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            leftSideButton.centerYAnchor.constraint(equalTo: skinAreaView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            skinAreaView.centerXAnchor.constraint(equalTo: centerXAnchor),
            skinAreaView.widthAnchor.constraint(equalToConstant: 146.14.scale),
            skinAreaView.heightAnchor.constraint(equalToConstant: 474.75.scale),
            skinAreaView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 93.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightSideButton.widthAnchor.constraint(equalToConstant: 24.scale),
            rightSideButton.heightAnchor.constraint(equalToConstant: 24.scale),
            rightSideButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            rightSideButton.centerYAnchor.constraint(equalTo: skinAreaView.centerYAnchor)
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
private extension SaveAnalyseSelectSkinAreaView {
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Back.Black"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 22.scale))
            .lineHeight(30.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "SaveAnalyseSelectSkinArea.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Roboto.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "SaveAnalyseSelectSkinArea.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSkinAreaView() -> SkinAreaView {
        let view = SkinAreaView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTapButton(iconName: String) -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: iconName), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let view = UIButton()
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
