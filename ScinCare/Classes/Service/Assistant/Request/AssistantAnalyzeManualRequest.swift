//
//  AssistantAnalyzeManualRequest.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import Alamofire

struct AssistantAnalyzeManualRequest: APIRequestBody {
    enum AssistantType {
        case math, physics, biology, chemistry
    }
    
    let anonymousId: String
    let internalId: String
    let assistantType: AssistantType
    let text: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/assistant/\(assistantType.extensionPath)/process"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "text": text
        ]
    }
}

// MARK: Additional
private extension AssistantAnalyzeManualRequest.AssistantType {
    var extensionPath: String {
        switch self {
        case .math:
            return "math"
        case .physics:
            return "physics"
        case .biology:
            return "biology"
        case .chemistry:
            return "chemistry"
        }
    }
}
