//
//  AssistantHistoryRequest.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 12.09.2024.
//

import Alamofire

struct AssistantHistoryRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let page: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/assistant/history"
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
            "page": page
        ]
    }
}
