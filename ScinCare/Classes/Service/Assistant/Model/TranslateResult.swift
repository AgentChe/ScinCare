//
//  TranslateResult.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import Foundation

struct TranslateResult {
    let languageCode: String
    let translate: String
}

// MARK: Public
extension TranslateResult {
    static func map(data: Data?) -> TranslateResult? {
        guard
            let data,
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let body = json["body"] as? [String: Any],
            let languageCode = body["lang"] as? String,
            let translate = body["translate"] as? String
        else { return nil }
        
        return TranslateResult(languageCode: languageCode, translate: translate)
    }
    
    static func map(response: Any) -> TranslateResult? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let languageCode = body["lang"] as? String,
            let translate = body["translate"] as? String
        else { return nil }
        
        return TranslateResult(languageCode: languageCode, translate: translate)
    }
}
