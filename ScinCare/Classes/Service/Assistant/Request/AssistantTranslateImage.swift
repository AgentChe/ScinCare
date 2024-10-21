//
//  AssistantTranslateImage.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import UIKit
import Alamofire

final class AssistantTranslateImage {
    private lazy var sessionManager = SessionManager()
    
    func upload(image: UIImage, languageCode: String, completion: ((TranslateResult?) -> Void)? = nil) {
        let url = URL(string: GlobalDefinitions.domain + "/api/v1/assistant/language/analyze")
        let jpeg = image.jpegData(compressionQuality: 0.5)
        let lang = languageCode.data(using: .utf8)
        let anonymousId = sessionManager.anonymousId.data(using: .utf8)
        let internalId = sessionManager.internalId.data(using: .utf8)
        
        guard let url, let jpeg, let lang, let anonymousId, let internalId else {
            completion?(nil)
            return
        }
        
        let headers: HTTPHeaders = [
            "Access-Token": GlobalDefinitions.apiKey
        ]
        
        let request = AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(jpeg, withName: "image", fileName: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg")
            multipartFormData.append(lang, withName: "lang")
            multipartFormData.append(anonymousId, withName: "anonymous_id")
            multipartFormData.append(internalId, withName: "internal_id")
        }, to: url, headers: headers)
        
        request
            .response { response in
                guard let data = response.data else {
                    completion?(nil)
                    return
                }
                
                let result = TranslateResult.map(data: data)
                completion?(result)
            }
    }
}
