//
//  AssistantAnalyzeWritingProcessRequest.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import Alamofire

struct AssistantAnalyzeWritingProcessRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let threadId: String
    let isRepeat: Bool
    
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
            "thread_id": threadId,
            "repeat": isRepeat
        ]
    }
}
