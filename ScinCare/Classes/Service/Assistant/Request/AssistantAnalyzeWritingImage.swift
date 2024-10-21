//
//  AssistantAnalyzeWritingImage.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import UIKit
import Alamofire

final class AssistantAnalyzeWritingImage {
    private lazy var sessionManager = SessionManager()
    
    func upload(image: UIImage, mode: WritingMode, style: WritingStyle, completion: ((AssistantAnalyzeImageResult?) -> Void)? = nil) {
        let url = URL(string: GlobalDefinitions.domain + "/api/v1/assistant/writing/analyze")
        let jpeg = image.jpegData(compressionQuality: 0.5)
        let mode = mode.parameterName.data(using: .utf8)
        let style = style.parameterName.data(using: .utf8)
        let anonymousId = sessionManager.anonymousId.data(using: .utf8)
        let internalId = sessionManager.internalId.data(using: .utf8)
        
        guard let url, let jpeg, let mode, let style, let anonymousId, let internalId else {
            completion?(nil)
            return
        }
        
        let headers: HTTPHeaders = [
            "Access-Token": GlobalDefinitions.apiKey
        ]
        
        let request = AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(jpeg, withName: "image", fileName: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg")
            multipartFormData.append(mode, withName: "mode")
            multipartFormData.append(style, withName: "style")
            multipartFormData.append(anonymousId, withName: "anonymous_id")
            multipartFormData.append(internalId, withName: "internal_id")
        }, to: url, headers: headers)
        
        request
            .response { response in
                guard let data = response.data else {
                    completion?(nil)
                    return
                }
                
                let result = AssistantAnalyzeImageResult.map(response: data)
                completion?(result)
            }
    }
}

// MARK: Additional
private extension WritingMode {
    var parameterName: String {
        switch self {
        case .outline:
            return "outline"
        case .essay:
            return "essay"
        }
    }
}

// MARK: Additional
private extension WritingStyle {
    var parameterName: String {
        switch self {
        case .expository:
            return "expository"
        case .narrative:
            return "narrative"
        case .argumentative:
            return "argumentative"
        case .analytical:
            return "analytical"
        case .research:
            return "research"
        case .descriptive:
            return "descriptive"
        case .omparative:
            return "omparative"
        case .other:
            return "other"
        }
    }
}
