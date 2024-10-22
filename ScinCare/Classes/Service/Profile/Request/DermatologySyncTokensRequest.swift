//
//  DermatologySyncTokensRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import Alamofire

struct DermatologySyncTokensRequest: APIRequestBody {
    let oldToken: String
    let newToken: String
    
    var url: String {
        GlobalDefinitions.dermatologyDomain + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.dermatologyApiKey,
            "user_token": newToken,
            "_user_token": oldToken
        ]
    }
}
