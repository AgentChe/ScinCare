//
//  SkinAreaItemView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 02.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SkinAreaItemView: UIImageView {
    lazy var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    let skinArea: SkinArea
    
    private lazy var tapGesture = UITapGestureRecognizer()
    
    init(skinArea: SkinArea) {
        self.skinArea = skinArea
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SkinAreaItemView {
    var didTap: Signal<SkinArea> {
        tapGesture.rx.event
            .compactMap { [weak self] event in self?.skinArea }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension SkinAreaItemView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    func update() {
        let imageName = marked ? skinArea.sImageName : skinArea.dImageName
        image = UIImage(named: imageName)
    }
}

// MARK: Additional
private extension SkinArea {
    var sImageName: String {
        switch self {
        case .head:
            return "SkinArea.Head.S"
        case .body:
            return "SkinArea.Body.S"
        case .leftArm:
            return "SkinArea.Body.LeftArm.S"
        case .rightArm:
            return "SkinArea.Body.RightArm.S"
        case .stomach:
            return "SkinArea.Body.Stomach.S"
        case .leftLeg:
            return "SkinArea.Body.LeftLeg.S"
        case .rightLeg:
            return "SkinArea.Body.RightLeg.S"
        }
    }
    
    var dImageName: String {
        switch self {
        case .head:
            return "SkinArea.Head.D"
        case .body:
            return "SkinArea.Body.D"
        case .leftArm:
            return "SkinArea.Body.LeftArm.D"
        case .rightArm:
            return "SkinArea.Body.RightArm.D"
        case .stomach:
            return "SkinArea.Body.Stomach.D"
        case .leftLeg:
            return "SkinArea.Body.LeftLeg.D"
        case .rightLeg:
            return "SkinArea.Body.RightLeg.D"
        }
    }
}
