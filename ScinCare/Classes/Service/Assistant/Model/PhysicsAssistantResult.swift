//
//  PhysicsAssistantResult.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import Foundation

struct PhysicsAssistantResult {
    struct Request {
        let imageUrl: URL?
        let content: String // html текст
    }
    
    struct Response {
        let userRawInput: String? // html текст
        let body: String // html текст
        let explanation: String // html текст
        let recommendation: String // html текст
    }
    
    let threadId: String
    let helpful: Bool?
    let created: TimeInterval
    let request: Request
    let response: Response
}

// MARK: Public
extension PhysicsAssistantResult {
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
        
        self = PhysicsAssistantResult(
            threadId: threadId,
            helpful: body["helpful"] as? Bool,
            created: created,
            request: request,
            response: response
        )
    }
    
    static func map(response: Any) -> PhysicsAssistantResult? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        return PhysicsAssistantResult(body: body)
    }
    
    func helpful(_ helpful: Bool?) -> PhysicsAssistantResult {
        PhysicsAssistantResult(
            threadId: threadId,
            helpful: helpful,
            created: created,
            request: request,
            response: response
        )
    }
}

// MARK: Public
extension PhysicsAssistantResult.Response {
    static func map(content: [String: Any]) -> PhysicsAssistantResult.Response? {
        guard
            let body = content["body"] as? String,
            let explanation = content["explanation"] as? String,
            let recommendation = content["recommendation"] as? String
        else { return nil }
        
        return PhysicsAssistantResult.Response(
            userRawInput: content["user_raw_input"] as? String,
            body: body,
            explanation: explanation,
            recommendation: recommendation
        )
    }
}
