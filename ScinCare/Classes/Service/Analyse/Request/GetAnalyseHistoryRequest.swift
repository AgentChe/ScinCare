//
//  GetAnalyseHistoryRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import Alamofire

struct GetAnalyseHistoryRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/ai/analyses/history"
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
        var params: Parameters = [
            "anonymous_id": anonymousId,
        ]
        
        if let internalId {
            params["internal_id"] = internalId
        }
        
        return params
    }
}
