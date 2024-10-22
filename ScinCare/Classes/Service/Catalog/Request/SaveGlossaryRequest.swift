//
//  SaveGlossaryRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import Alamofire

struct SaveGlossaryRequest: APIRequestBody {
    let userToken: String
    let id: Int

    var url: String {
        GlobalDefinitions.dermatologyDomain + "/api/dermatologic_term/save"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.dermatologyApiKey,
            "_user_token": userToken,
            "dermatologic_term_id": id
        ]
    }
}
