//
//  Page.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 12.09.2024.
//

struct Page {
    let current: Int
    let nextPage: Int
    let total: Int
    
    init?(json: [String: Any]) {
        guard
            let current = json["page"] as? Int,
            let nextPage = json["next"] as? Int,
            let total = json["total"] as? Int
        else {
            return nil
        }
        
        self.current = current
        self.nextPage = nextPage
        self.total = total
    }
}
