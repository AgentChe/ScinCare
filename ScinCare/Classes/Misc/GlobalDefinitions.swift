//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://skin.thinkaboutapps.com"
    static let apiKey = "K9tK6iIQ4mZZNnWhs9c9y3DI"
    
    static let dermatologyDomain = "https://dermatology.awesum-apps.com"
    static let dermatologyApiKey = "7LexM8IGOSmIrpEimANw"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "32xQjC9GIHM8NGbK"
    
    static let applicationTag = "DERMATOLOGY"
    static let amplitudeApiKey = "0d810afcbd45c0b58a5ed6cd272acfa"
    
    static let termsOfServiceUrl = URL(string: "https://thinkaboutapps.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://thinkaboutapps.com/policy")!
    static let contactUsUrl = URL(string: "https://thinkaboutapps.com/contact")!
    
    enum Paygate {
        static let yearly = "mobile.dermatology.yearly"
        static let weekly = "mobile.dermatology.weekly"
    }
}
