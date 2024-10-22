//
//  CatalogSection.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

struct CatalogSection: Codable, Hashable {
    let name: String
    let blocks: [CatalogBlock]
}

// MARK: Public
extension CatalogSection {
    init?(json: [String: Any]) {
        guard
            let name = json["name"] as? String,
            let blocksArray = json["blocks"] as? [[String: Any]]
        else { return nil }
        
        self.name = name
        self.blocks = blocksArray.compactMap { CatalogBlock(json: $0) }
    }
}
