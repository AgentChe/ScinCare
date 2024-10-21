//
//  MathAssistantResult.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import Foundation

struct MathAssistantResult {
    struct Request {
        let imageUrl: URL?
        let content: String // latex текст
    }
    
    struct Response {
        let userFormula: String? // latex текст
        let userRawInput: String? // latex текст
        let body: String // latex текст
        let explanation: String? // latex текст
        let recommendation: String? // latex текст
    }
    
    let threadId: String
    let helpful: Bool?
    let created: TimeInterval
    let request: Request
    let response: Response
}

// MARK: Public
extension MathAssistantResult {
    init?(body: [String: Any]) {
        guard
            let threadId = body["thread_id"] as? String,
            let content = body["content"] as? [[String: Any]],
            let created = body["created_at"] as? TimeInterval
        else { return nil }
        
        let request: Request? = {
            for json in content {
                guard
                    let type = json["type"] as? String, type == "request",
                    let content = json["content"] as? String
                else { continue }
                
                let imageUrl: URL? = {
                    guard let path = json["image"] as? String else { return nil }
                    return URL(string: path)
                }()
                
                return Request(imageUrl: imageUrl, content: content)
            }
            
            return nil
        }()
        guard let request else { return nil }
        
        let response: Response? = {
            for json in content {
                guard
                    let type = json["type"] as? String, type == "response",
                    let content = json["content"] as? [String: Any]
                else { continue }
                
                return Response.map(content: content)
            }
            
            return nil
        }()
        guard let response else { return nil }
        
        self = MathAssistantResult(
            threadId: threadId,
            helpful: body["helpful"] as? Bool,
            created: created,
            request: request,
            response: response
        )
    }
    
    static func map(response: Any) -> MathAssistantResult? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        return MathAssistantResult(body: body)
    }
    
    func helpful(_ helpful: Bool?) -> MathAssistantResult {
        MathAssistantResult(
            threadId: threadId,
            helpful: helpful,
            created: created,
            request: request,
            response: response
        )
    }
}

// MARK: Public
extension MathAssistantResult.Response {
    static func map(content: [String: Any]) -> MathAssistantResult.Response? {
        guard let body = content["body"] as? String else { return nil }
        
        return MathAssistantResult.Response(
            userFormula: content["user_formula"] as? String,
            userRawInput: content["user_raw_input"] as? String,
            body: body,
            explanation: content["explanation"] as? String,
            recommendation: content["recommendation"] as? String
        )
    }
}
