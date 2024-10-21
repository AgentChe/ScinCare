//
//  Appearance.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 23.04.2021.
//

import UIKit

struct Appearance {
    static let mono100 = UIColor.white
    static let mono200 = UIColor.black
    static let main100 = UIColor(integralRed: 104, green: 155, blue: 147)
    static let main200 = UIColor(integralRed: 200, green: 227, blue: 222)
    static let main300 = UIColor(integralRed: 82, green: 65, blue: 126)
    static let main400 = UIColor(integralRed: 197, green: 186, blue: 227)
    static let main700 = UIColor(integralRed: 252, green: 248, blue: 240)
    static let main800 = UIColor(integralRed: 239, green: 203, blue: 72)
    static let main900 = UIColor(integralRed: 239, green: 233, blue: 220)
    static let system100 = UIColor(integralRed: 235, green: 101, blue: 96)
    static let gradientColors = [
        Appearance.main700.withAlphaComponent(0).cgColor,
        Appearance.main700.withAlphaComponent(0.66).cgColor
    ]
}
