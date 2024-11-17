//
//  SASTScannedAreaImageView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 03.11.2024.
//

import UIKit

final class SASTScannedAreaImageView: UIView {
    lazy var imageView = makeImageView()
    
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
extension SASTScannedAreaImageView {
    func setup(side: Side, area: SkinArea) {
        let sName: String = {
            switch side {
            case .back:
                return "B"
            case .front:
                return "F"
            }
        }()
        let areaName: String = {
            switch area {
            case .head:
                return "Head"
            case .body:
                return "Body"
            case .leftArm:
                return "LeftArm"
            case .rightArm:
                return "RightArm"
            case .stomach:
                return "Stomach"
            case .leftLeg:
                return "LeftLeg"
            case .rightLeg:
                return "RightLeg"
            }
        }()
        let imageName = String(format: "SAST.%@.%@", sName, areaName)
        imageView.image = UIImage(named: imageName)
    }
}

// MARK: Private
private extension SASTScannedAreaImageView {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 12.scale
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main900.cgColor
    }
}

// MARK: Make constraints
private extension SASTScannedAreaImageView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SASTScannedAreaImageView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
