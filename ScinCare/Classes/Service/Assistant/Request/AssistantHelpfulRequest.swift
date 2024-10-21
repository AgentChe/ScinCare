//
//  AssistantHelpfulRequest.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import Alamofire

struct AssistantHelpfulRequest: APIRequestBody {
    enum AssistantType {
        case math, physics, biology, chemistry, writing
    }
    
    let assistantType: AssistantType
    let anonymousId: String
    let internalId: String
    let threadId: String
    let helpful: Bool
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/assistant/\(assistantType.extensionPath)/helpful"
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
            "thread_id": threadId,
            "helpful": helpful
        ]
    }
}

// MARK: Additional
private extension AssistantHelpfulRequest.AssistantType {
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
        case .writing:
            return "writing"
        }
    }
}
