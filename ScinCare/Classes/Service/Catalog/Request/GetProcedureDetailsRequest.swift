//
//  GetProcedureDetailsRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import Alamofire

struct GetProcedureDetailsRequest: APIRequestBody {
    let userToken: String
    let id: Int
    
    var url: String {
        GlobalDefinitions.dermatologyDomain + "/api/procedure/details"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.dermatologyApiKey,
            "_user_token": userToken,
            "procedure_id": id
        ]
    }
}
