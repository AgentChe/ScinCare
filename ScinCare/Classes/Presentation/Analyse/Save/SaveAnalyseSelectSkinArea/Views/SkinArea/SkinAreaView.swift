//
//  SkinAreaView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 02.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SkinAreaView: UIView {
    lazy var sideImageView = makeImageView()
    lazy var headItemView = makeItemView(skinArea: .head)
    lazy var bodyItemView = makeItemView(skinArea: .body)
    lazy var leftArmItemView = makeItemView(skinArea: .leftArm)
    lazy var rightArmItemView = makeItemView(skinArea: .rightArm)
    lazy var stomachItemView = makeItemView(skinArea: .stomach)
    lazy var leftLegItemView = makeItemView(skinArea: .leftLeg)
    lazy var rightLegItemView = makeItemView(skinArea: .rightLeg)
    
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
extension SkinAreaView {
    func setup(side: Side) {
        sideImageView.image = UIImage(named: side.imageName)
    }
    
    func setup(skinArea: SkinArea?) {
        [
            headItemView,
            bodyItemView,
            leftArmItemView,
            rightArmItemView,
            stomachItemView,
            leftLegItemView,
            rightLegItemView
        ].forEach { $0.marked = $0.skinArea == skinArea }
    }
    
    var didSelect: Signal<SkinArea> {
        Signal
            .merge(
                headItemView.didTap,
                bodyItemView.didTap,
                leftArmItemView.didTap,
                rightArmItemView.didTap,
                stomachItemView.didTap,
                leftLegItemView.didTap,
                rightLegItemView.didTap
            )
    }
}

// MARK: Private
private extension SkinAreaView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension SkinAreaView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            sideImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sideImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sideImageView.topAnchor.constraint(equalTo: topAnchor),
            sideImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headItemView.widthAnchor.constraint(equalToConstant: 33.scale),
            headItemView.heightAnchor.constraint(equalToConstant: 48.scale),
            headItemView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 56.scale),
            headItemView.topAnchor.constraint(equalTo: topAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            bodyItemView.widthAnchor.constraint(equalToConstant: 66.scale),
            bodyItemView.heightAnchor.constraint(equalToConstant: 117.scale),
            bodyItemView.centerXAnchor.constraint(equalTo: headItemView.centerXAnchor),
            bodyItemView.topAnchor.constraint(equalTo: topAnchor, constant: 90.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftArmItemView.widthAnchor.constraint(equalToConstant: 20.scale),
            leftArmItemView.heightAnchor.constraint(equalToConstant: 111.scale),
            leftArmItemView.trailingAnchor.constraint(equalTo: bodyItemView.leadingAnchor),
            leftArmItemView.topAnchor.constraint(equalTo: topAnchor, constant: 110.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightArmItemView.widthAnchor.constraint(equalToConstant: 20.scale),
            rightArmItemView.heightAnchor.constraint(equalToConstant: 111.scale),
            rightArmItemView.leadingAnchor.constraint(equalTo: bodyItemView.trailingAnchor),
            rightArmItemView.topAnchor.constraint(equalTo: topAnchor, constant: 110.scale)
        ])
        
        NSLayoutConstraint.activate([
            stomachItemView.widthAnchor.constraint(equalToConstant: 59.scale),
            stomachItemView.heightAnchor.constraint(equalToConstant: 16.scale),
            stomachItemView.centerXAnchor.constraint(equalTo: headItemView.centerXAnchor),
            stomachItemView.topAnchor.constraint(equalTo: topAnchor, constant: 209.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftLegItemView.widthAnchor.constraint(equalToConstant: 27.scale),
            leftLegItemView.heightAnchor.constraint(equalToConstant: 181.scale),
            leftLegItemView.leadingAnchor.constraint(equalTo: bodyItemView.leadingAnchor, constant: 2.scale),
            leftLegItemView.topAnchor.constraint(equalTo: stomachItemView.bottomAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightLegItemView.widthAnchor.constraint(equalToConstant: 27.scale),
            rightLegItemView.heightAnchor.constraint(equalToConstant: 181.scale),
            rightLegItemView.trailingAnchor.constraint(equalTo: bodyItemView.trailingAnchor, constant: -2.scale),
            rightLegItemView.topAnchor.constraint(equalTo: stomachItemView.bottomAnchor, constant: 4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SkinAreaView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItemView(skinArea: SkinArea) -> SkinAreaItemView {
        let view = SkinAreaItemView(skinArea: skinArea)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension Side {
    var imageName: String {
        switch self {
        case .front:
            return "Side.Front"
        case .back:
            return "Side.Back"
        }
    }
}
