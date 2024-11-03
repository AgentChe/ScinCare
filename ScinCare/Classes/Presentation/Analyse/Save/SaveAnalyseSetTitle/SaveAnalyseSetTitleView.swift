//
//  SaveAnalyseSetTitleView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 02.11.2024.
//

import UIKit

final class SaveAnalyseSetTitleView: UIView {
    lazy var backButton = makeBackButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var scannedAreaView = makeScannedAreaView()
    lazy var inputField = makeInputField()
    lazy var saveButton = makeSaveButton()
    lazy var preloader = makePreloader()
    
    private lazy var saveButtonEnableAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Roboto.bold(size: 16.scale))
    private lazy var saveButtonDisableAttrs = TextAttributes()
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
extension SaveAnalyseSetTitleView {
    func saveButton(enable: Bool) {
        saveButton.isUserInteractionEnabled = enable
        
        saveButton.backgroundColor = enable ? Appearance.main100 : Appearance.main900
        
        let attrs = enable ? saveButtonEnableAttrs : saveButtonDisableAttrs
        saveButton.setAttributedTitle("SaveAnalyseSetTitle.SaveButton".localized.attributed(with: attrs), for: .normal)
    }
}

// MARK: Private
private extension SaveAnalyseSetTitleView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension SaveAnalyseSetTitleView {
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
            scannedAreaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scannedAreaView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scannedAreaView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 29.scale)
        ])
        
        NSLayoutConstraint.activate([
            inputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            inputField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            inputField.topAnchor.constraint(equalTo: scannedAreaView.bottomAnchor, constant: 34.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 54.scale),
            saveButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -14.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 42.scale),
            preloader.heightAnchor.constraint(equalToConstant: 42.scale),
            preloader.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SaveAnalyseSetTitleView {
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
        view.attributedText = "SaveAnalyseSetTitle.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScannedAreaView() -> SASTScannedAreaView {
        let view = SASTScannedAreaView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInputField() -> SASTInputField {
        let view = SASTInputField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSaveButton() -> UIButton {
        let view = UIButton()
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true 
        view.style = .large
        view.color = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
