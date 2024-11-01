//
//  AnalyseImageResizeOptionsView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class AnalyseImageResizeOptionsView: UIView {
    enum State {
        case acceptPhoto
        case preloader
        case correct
        case incorrect
    }
    
    private lazy var whiteButtonAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Roboto.bold(size: 16.scale))
    private lazy var blackButtonAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.bold(size: 16.scale))
    private lazy var disableButtonAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.Roboto.bold(size: 16.scale))
    private lazy var textAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.Roboto.bold(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
    
    private lazy var didAcceptPhotoTrigger = PublishRelay<Void>()
    private lazy var didRetakePhotoTrigger = PublishRelay<Void>()
    private lazy var didContinueTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AnalyseImageResizeOptionsView {
    func setup(state: State) {
        subviews.forEach { $0.removeFromSuperview() }
        buildUI(state: state)
        layoutIfNeeded()
    }
    
    var didAcceptPhoto: Signal<Void> {
        didAcceptPhotoTrigger.asSignal()
    }
    
    var didRetakePhoto: Signal<Void> {
        didRetakePhotoTrigger.asSignal()
    }
    
    var didContinue: Signal<Void> {
        didContinueTrigger.asSignal()
    }
}

// MARK: Private
private extension AnalyseImageResizeOptionsView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func buildUI(state: State) {
        switch state {
        case .acceptPhoto:
            buildAcceptPhotoUI()
        case .preloader:
            buildPreloaderUI()
        case .correct:
            buildCorrectUI()
        case .incorrect:
            buildIncorrectUI()
        }
    }
    
    func buildAcceptPhotoUI() {
        let acceptButton = UIButton()
        acceptButton.setAttributedTitle("AnalyseImageResize.AcceptPhoto".localized.attributed(with: whiteButtonAttrs), for: .normal)
        acceptButton.backgroundColor = Appearance.main100
        acceptButton.layer.cornerRadius = 16.scale
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        addSubview(acceptButton)
        
        let retakeButton = UIButton()
        retakeButton.setAttributedTitle("AnalyseImageResize.Retake".localized.attributed(with: blackButtonAttrs), for: .normal)
        retakeButton.backgroundColor = Appearance.main900
        retakeButton.layer.cornerRadius = 16.scale
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        retakeButton.addTarget(self, action: #selector(retakeTapped), for: .touchUpInside)
        addSubview(retakeButton)
        
        NSLayoutConstraint.activate([
            acceptButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            acceptButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            acceptButton.heightAnchor.constraint(equalToConstant: 54.scale),
            acceptButton.bottomAnchor.constraint(equalTo: retakeButton.topAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            retakeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            retakeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            retakeButton.heightAnchor.constraint(equalToConstant: 54.scale),
            retakeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35.scale)
        ])
    }
    
    func buildPreloaderUI() {
        let preloader = UIActivityIndicatorView()
        preloader.style = .medium
        preloader.color = Appearance.main100
        preloader.startAnimating()
        preloader.translatesAutoresizingMaskIntoConstraints = false
        addSubview(preloader)
        
        let label = UILabel()
        label.attributedText = "AnalyseImageResize.Preloader".localized.attributed(with: textAttrs)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        let continueButton = UIButton()
        continueButton.setAttributedTitle("Continue".localized.attributed(with: disableButtonAttrs), for: .normal)
        continueButton.backgroundColor = Appearance.main900
        continueButton.layer.cornerRadius = 16.scale
        continueButton.isUserInteractionEnabled = false 
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 24.scale),
            preloader.heightAnchor.constraint(equalToConstant: 24.scale),
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: preloader.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35.scale)
        ])
    }
    
    func buildCorrectUI() {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.image = UIImage(named: "AnalyseImageResize.Correct")
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        
        let label = UILabel()
        label.attributedText = "AnalyseImageResize.Correct".localized.attributed(with: textAttrs)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        let continueButton = UIButton()
        continueButton.setAttributedTitle("Continue".localized.attributed(with: whiteButtonAttrs), for: .normal)
        continueButton.backgroundColor = Appearance.main100
        continueButton.layer.cornerRadius = 16.scale
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35.scale)
        ])
    }
    
    func buildIncorrectUI() {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.image = UIImage(named: "AnalyseImageResize.Incorrect")
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        
        let label = UILabel()
        label.attributedText = "AnalyseImageResize.Incorrect".localized.attributed(with: textAttrs)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        let retakeButton = UIButton()
        retakeButton.setAttributedTitle("AnalyseImageResize.RetakePhoto".localized.attributed(with: whiteButtonAttrs), for: .normal)
        retakeButton.backgroundColor = Appearance.main100
        retakeButton.layer.cornerRadius = 16.scale
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        retakeButton.addTarget(self, action: #selector(retakeTapped), for: .touchUpInside)
        addSubview(retakeButton)
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            retakeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            retakeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            retakeButton.heightAnchor.constraint(equalToConstant: 54.scale),
            retakeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35.scale)
        ])
    }
    
    @objc
    func acceptTapped() {
        didAcceptPhotoTrigger.accept(Void())
    }
    
    @objc
    func retakeTapped() {
        didRetakePhotoTrigger.accept(Void())
    }
    
    @objc
    func continueTapped() {
        didContinueTrigger.accept(Void())
    }
}
