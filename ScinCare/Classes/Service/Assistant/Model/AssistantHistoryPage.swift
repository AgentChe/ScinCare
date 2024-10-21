//
//  AssistantHistoryPage.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 12.09.2024.
//

struct AssistantHistoryPage {
    let history: [AssistantHistoryItem]
    let page: Page
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        let history: [AssistantHistoryItem]? = {
            guard let array = body["history"] as? [[String: Any]] else { return nil }
            return array.compactMap { item -> AssistantHistoryItem? in
                AssistantHistoryPage.map(item: item)
            }
        }()
        guard let history else { return nil }
        
        let page: Page? = {
            guard let pagination = body["pagination"] as? [String: Any] else { return nil }
            return Page(json: pagination)
        }()
        guard let page else { return nil }
        
        self.history = history
        self.page = page
    }
}

// MARK: Private
private extension AssistantHistoryPage {
    static func map(item: [String: Any]) -> AssistantHistoryItem? {
        guard let type = item["type"] as? String else { return nil }
        
        switch type {
        case "math":
            guard let result = MathAssistantResult(body: item) else { return nil }
            return .math(result)
        case "physics":
            guard let result = PhysicsAssistantResult(body: item) else { return nil }
            return .physics(result)
        case "biology":
            guard let result = BiologyAssistantResult(body: item) else { return nil }
            return .biology(result)
        case "chemistry":
            guard let result = ChemistryAssistantResult(body: item) else { return nil }
            return .chemistry(result)
        case "writing":
            guard let result = WritingAssistantResult(body: item) else { return nil }
            return .writing(result)
        default:
            return nil
        }
    }
}
