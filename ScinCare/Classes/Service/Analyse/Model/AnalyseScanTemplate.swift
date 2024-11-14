//
//  AnalyseScanTemplate.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import Foundation

struct AnalyseScanTemplate {
    let id: String
    let created: Date
    let name: String
    let image: URL
}

// MARK: Public
extension AnalyseScanTemplate {
    static func map(response: Any) -> [AnalyseScanTemplate]? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [[String: Any]]
        else { return nil }
        
        return body.compactMap { AnalyseScanTemplate(json: $0) }
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["analyses_id"] as? String,
            let created: Date = {
                guard let timestamp = json["created_at"] as? TimeInterval else { return nil }
                return Date(timeIntervalSince1970: timestamp)
            }(),
            let name = json["name"] as? String,
            let image: URL = {
                guard let path = json["image"] as? String else { return nil }
                return URL(string: path)
            }()
        else { return nil }
        
        self.id = id
        self.created = created
        self.name = name
        self.image = image
    }
}
