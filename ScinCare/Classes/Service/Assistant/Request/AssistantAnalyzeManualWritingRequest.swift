//
//  AssistantAnalyzeManualWritingRequest.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import Alamofire

struct AssistantAnalyzeManualWritingRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let text: String
    let mode: WritingMode
    let style: WritingStyle
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/assistant/writing/process"
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
            "text": text,
            "mode": mode.parameterName,
            "style": style.parameterName
        ]
    }
}

// MARK: Additional
private extension WritingMode {
    var parameterName: String {
        switch self {
        case .outline:
            return "outline"
        case .essay:
            return "essay"
        }
    }
}

// MARK: Additional
private extension WritingStyle {
    var parameterName: String {
        switch self {
        case .expository:
            return "expository"
        case .narrative:
            return "narrative"
        case .argumentative:
            return "argumentative"
        case .analytical:
            return "analytical"
        case .research:
            return "research"
        case .descriptive:
            return "descriptive"
        case .omparative:
            return "omparative"
        case .other:
            return "other"
        }
    }
}
