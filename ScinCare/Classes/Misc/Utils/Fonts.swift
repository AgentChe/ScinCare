//
//  Fonts.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: Roboto
    struct Roboto {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Roboto-Bold", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Roboto-Medium", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Roboto-Regular", size: size)!
        }
    }
}
