//
//  Catalog.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

struct Catalog: Codable, Hashable {
    let id: Int
    let name: String
    let saved: Bool
}

// MARK: Public
extension Catalog {
    static func map(response: Any) -> [Catalog] {
        guard
           let json = response as? [String: Any],
           let data = json["_data"] as? [String: Any],
           let drugs = data["drugs"] as? [[String: Any]]
       else { return [] }
            
        return drugs.compactMap { Catalog(json: $0) }
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let saved = json["saved"] as? Bool
        else { return nil }
        
        self.id = id
        self.name = name
        self.saved = saved
    }
}
