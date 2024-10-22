//
//  GetGlossariesRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import Alamofire

struct GetGlossariesRequest: APIRequestBody {
    let userToken: String
    let search: String?

    var url: String {
        GlobalDefinitions.dermatologyDomain + "/api/dermatologic_term"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params = [
            "_api_key": GlobalDefinitions.dermatologyApiKey,
            "_user_token": userToken
        ]
        
        if let search = search {
            params["search"] = search
        }
        
        return params
    }
}
