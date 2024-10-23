//
//  UnsaveDiseaseRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import Alamofire

struct UnsaveDiseaseRequest: APIRequestBody {
    let userToken: String
    let ids: [Int]

    var url: String {
        GlobalDefinitions.dermatologyDomain + "/api/disease/unsave"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.dermatologyApiKey,
            "_user_token": userToken,
            "diseases_ids": ids
        ]
    }
}
