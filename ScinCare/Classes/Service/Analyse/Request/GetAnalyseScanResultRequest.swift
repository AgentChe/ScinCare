//
//  GetAnalyseScanResultRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import Alamofire

struct GetAnalyseScanResultRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let analyseId: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/ai/analyses/get"
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
            "analyses_id": analyseId
        ]
        
        if let internalId {
            params["internal_id"] = internalId
        }
        
        return params
    }
}
