//
//  SaveDiseaseRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import Alamofire

struct SaveDiseaseRequest: APIRequestBody {
    let userToken: String
    let id: Int

    var url: String {
        GlobalDefinitions.domain + "/api/disease/save"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "disease_id": id
        ]
    }
}
