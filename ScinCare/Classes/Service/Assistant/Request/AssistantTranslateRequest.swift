//
//  AssistantTranslateRequest.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import Alamofire

struct AssistantTranslateRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let text: String
    let languageCode: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/assistant/language/translate"
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
            "lang": languageCode
        ]
    }
}
