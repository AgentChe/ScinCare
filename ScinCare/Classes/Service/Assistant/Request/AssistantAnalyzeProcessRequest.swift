//
//  AssistantAnalyzeProcessRequest.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import Alamofire

struct AssistantAnalyzeProcessRequest: APIRequestBody {
    enum AssistantType {
        case math, physics, biology, chemistry
    }
    
    let assistantType: AssistantType
    let anonymousId: String
    let internalId: String
    let threadId: String
    let isRepeat: Bool
    
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
            "thread_id": threadId,
            "repeat": isRepeat
        ]
    }
}

// MARK: Additional
private extension AssistantAnalyzeProcessRequest.AssistantType {
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
