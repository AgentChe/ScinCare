//
//  CatalogDetails.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

struct CatalogDetails: Codable, Hashable {
    let id: Int
    let name: String
    let saved: Bool
    let sections: [CatalogSection]
}

// MARK: Public
extension CatalogDetails {
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let id = data["id"] as? Int,
            let name = data["name"] as? String,
            let saved = data["saved"] as? Bool,
            let sectionsArray = data["sections"] as? [[String: Any]]
        else { return nil }
        
        self.id = id
        self.name = name
        self.saved = saved
        self.sections = sectionsArray.compactMap { CatalogSection(json: $0) }
    }
}
