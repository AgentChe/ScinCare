//
//  Language.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

struct Language: Codable, Hashable {
    let code: String
    let name: String
}

// MARK: Public
extension Language {
    static func map(response: Any) -> [Language] {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [[String: Any]]
        else { return [] }
        
        return body.compactMap { json -> Language? in
            guard
                let code = json["language"] as? String,
                let name = json["name"] as? String
            else { return nil }
            
            return Language(code: code, name: name)
        }
    }
}
