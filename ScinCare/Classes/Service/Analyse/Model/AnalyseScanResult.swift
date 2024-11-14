//
//  AnalyseScanResult.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import Foundation

struct AnalyseScanResult {
    let id: String
    let name: String
    let image: URL
    let saved: Bool
    let assessment: AnalyseScanAssessment?
    let conclusion: AnalyseScanConclusion?
    let recommendations: [AnalyseScanRecommendation]?
    let description: String?
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let id = body["analyses_id"] as? String,
            let name = body["name"] as? String,
            let image: URL = {
                guard let path = body["image"] as? String else { return nil }
                return URL(string: path)
            }()
        else { return nil }
        
        self.id = id
        self.name = name
        self.image = image
        self.saved = body["saved"] as? Bool ?? false
        self.assessment = {
            guard let json = body["assessment"] as? [String: Any] else { return nil }
            return AnalyseScanAssessment(json: json)
        }()
        self.conclusion = {
            guard let json = body["conclusion"] as? [String: Any] else { return nil }
            return AnalyseScanConclusion(json: json)
        }()
        self.recommendations = {
            guard let array = body["recommendation"] as? [[String: Any]] else { return nil }
            return array.compactMap { AnalyseScanRecommendation(json: $0) }
        }()
        self.description = body["description"] as? String
    }
}

struct AnalyseScanAssessment {
    let status: String
    let description: String
    
    init?(json: [String: Any]) {
        guard
            let status = json["status"] as? String,
            let description = json["description"] as? String
        else { return nil }
        
        self.status = status
        self.description = description
    }
}

struct AnalyseScanConclusion {
    let value: String
    let percent: Double
    
    init?(json: [String: Any]) {
        guard
            let value = json["value"] as? String,
            let percent = json["percent"] as? Double
        else { return nil }
        
        self.value = value
        self.percent = percent
    }
}

struct AnalyseScanRecommendation {
    let step: Int
    let content: String
    
    init?(json: [String: Any]) {
        guard
            let step = json["step"] as? Int,
            let content = json["content"] as? String
        else { return nil }
        
        self.step = step
        self.content = content
    }
}
