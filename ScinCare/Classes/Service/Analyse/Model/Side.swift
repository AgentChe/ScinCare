//
//  Side.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 02.11.2024.
//

enum Side {
    case front, back
    
    var localized: String {
        switch self {
        case .front:
            return "Side.Front".localized
        case .back:
            return "Side.Back".localized
        }
    }
}

enum SkinArea {
    case head
    case body
    case leftArm
    case rightArm
    case stomach
    case leftLeg
    case rightLeg
    
    var localized: String {
        switch self {
        case .head:
            return "SkinArea.Head".localized
        case .body:
            return "SkinArea.Body".localized
        case .leftArm:
            return "SkinArea.leftArm".localized
        case .rightArm:
            return "SkinArea.RightArm".localized
        case .stomach:
            return "SkinArea.Stomach".localized
        case .leftLeg:
            return "SkinArea.LeftLeg".localized
        case .rightLeg:
            return "SkinArea.RightLeg".localized
        }
    }
}
