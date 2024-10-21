//
//  GetLanguagesRequest.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import Alamofire

struct GetLanguagesRequest: APIRequestBody {
    var url: String {
        GlobalDefinitions.domain + "/api/v1/assistant/language/languages"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
}
