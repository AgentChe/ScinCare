//
//  AnalyseCameraOptionsView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit

final class AnalyseCameraOptionsView: UIView {
    lazy var refreshButton = makeButton(iconName: "AnalyseCamera.Refresh")
    lazy var minusButton = makeButton(iconName: "AnalyseCamera.Minus")
    lazy var sliderView = makeSliderView()
    lazy var plusButton = makeButton(iconName: "AnalyseCamera.Plus")
    lazy var wallpapersButton = makeButton(iconName: "AnalyseCamera.Wallpapers")
    
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
private extension AnalyseCameraOptionsView {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 25.scale
        layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.scale
    }
}

// MARK: Make constraints
private extension AnalyseCameraOptionsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            refreshButton.widthAnchor.constraint(equalToConstant: 46.scale),
            refreshButton.heightAnchor.constraint(equalToConstant: 46.scale),
            refreshButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13.5.scale),
            refreshButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            minusButton.widthAnchor.constraint(equalToConstant: 24.scale),
            minusButton.heightAnchor.constraint(equalToConstant: 24.scale),
            minusButton.trailingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: -12.scale),
            minusButton.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sliderView.widthAnchor.constraint(equalToConstant: 100.scale),
            sliderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            sliderView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 24.scale),
            plusButton.heightAnchor.constraint(equalToConstant: 24.scale),
            plusButton.leadingAnchor.constraint(equalTo: sliderView.trailingAnchor, constant: 12.scale),
            plusButton.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            wallpapersButton.widthAnchor.constraint(equalToConstant: 46.scale),
            wallpapersButton.heightAnchor.constraint(equalToConstant: 46.scale),
            wallpapersButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13.5.scale),
            wallpapersButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AnalyseCameraOptionsView {
    func makeButton(iconName: String) -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: iconName), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSliderView() -> UISlider {
        let view = UISlider()
        view.minimumTrackTintColor = Appearance.main100
        view.maximumTrackTintColor = Appearance.main100
        view.tintColor = Appearance.main100
        view.minimumValue = 1
        view.maximumValue = 10
        view.value = 1
        view.isUserInteractionEnabled = false 
        view.setThumbImage(UIImage(named: "AnalyseCamera.Thumb"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
