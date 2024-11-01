//
//  AnalyseCameraView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit

final class AnalyseCameraView: UIView {
    lazy var cameraContainer = makeCameraContainer()
    lazy var closeButton = makeCloseButton()
    lazy var placeholderView = makePlaceholderView()
    lazy var takePhotoButton = makeTakePhotoButton()
    lazy var placeholderLabel = makePlaceholder()
    lazy var optionsView = makeOptionsView()
    
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
private extension AnalyseCameraView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension AnalyseCameraView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            cameraContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            cameraContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            cameraContainer.topAnchor.constraint(equalTo: topAnchor),
            cameraContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -177.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            placeholderView.widthAnchor.constraint(equalToConstant: 255.scale),
            placeholderView.heightAnchor.constraint(equalToConstant: 255.scale),
            placeholderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderView.topAnchor.constraint(equalTo: topAnchor, constant: 206.scale)
        ])
        
        NSLayoutConstraint.activate([
            takePhotoButton.widthAnchor.constraint(equalToConstant: 68.scale),
            takePhotoButton.heightAnchor.constraint(equalToConstant: 68.scale),
            takePhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            takePhotoButton.bottomAnchor.constraint(equalTo: cameraContainer.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: cameraContainer.bottomAnchor, constant: 23.scale)
        ])
        
        NSLayoutConstraint.activate([
            optionsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            optionsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            optionsView.heightAnchor.constraint(equalToConstant: 70.scale),
            optionsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AnalyseCameraView {
    func makeCameraContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 24.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "AnalyseCamera.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlaceholderView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "AnalyseCamera.Placeholder")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTakePhotoButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "AnalyseCamera.TakePhoto"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlaceholder() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Roboto.regular(size: 14.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = "AnalyseCamera.Placeholder".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOptionsView() -> AnalyseCameraOptionsView {
        let view = AnalyseCameraOptionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
