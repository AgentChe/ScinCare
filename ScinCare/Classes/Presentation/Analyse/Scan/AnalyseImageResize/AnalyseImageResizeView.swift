//
//  AnalyseImageResizeView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit

final class AnalyseImageResizeView: UIView {
    lazy var imageContainer = makeImageContainer()
    lazy var backButton = makeBackButton()
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
private extension AnalyseImageResizeView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension AnalyseImageResizeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageContainer.topAnchor.constraint(equalTo: topAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -177.scale)
        ])
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24.scale),
            backButton.heightAnchor.constraint(equalToConstant: 24.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            optionsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            optionsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            optionsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            optionsView.heightAnchor.constraint(equalToConstant: 153.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AnalyseImageResizeView {
    func makeImageContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 24.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Back.White"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOptionsView() -> AnalyseImageResizeOptionsView {
        let view = AnalyseImageResizeOptionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
