//
//  GetBookmarksProceduresRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import Alamofire

struct GetBookmarksProceduresRequest: APIRequestBody {
    let userToken: String

    var url: String {
        GlobalDefinitions.dermatologyDomain + "/api/procedure/bookmarks"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.dermatologyApiKey,
            "_user_token": userToken
        ]
    }
}
