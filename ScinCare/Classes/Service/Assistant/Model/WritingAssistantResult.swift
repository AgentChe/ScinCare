//
//  WritingAssistantResult.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import Foundation

struct WritingAssistantResult {
    struct Meta {
        let mode: WritingMode
        let style: WritingStyle
    }
    
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
    let meta: Meta
    let request: Request
    let response: Response
}

// MARK: Public
extension WritingAssistantResult {
    init?(body: [String: Any]) {
        guard
            let threadId = body["thread_id"] as? String,
            let content = body["content"] as? [[String: Any]],
            let created = body["created_at"] as? TimeInterval
        else { return nil }
        
        let meta: Meta? = {
            guard
                let metaJSON = body["meta"] as? [String: Any],
                let modeRawValue = metaJSON["mode"] as? String,
                let mode = WritingMode(meta: modeRawValue),
                let styleRawValue = metaJSON["style"] as? String,
                let style = WritingStyle(meta: styleRawValue)
            else { return nil }
            
            return Meta(mode: mode, style: style)
        }()
        guard let meta else { return nil }
        
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
        
        self = WritingAssistantResult(
            threadId: threadId,
            helpful: body["helpful"] as? Bool,
            created: created,
            meta: meta,
            request: request,
            response: response
        )
    }
    
    static func map(response: Any) -> WritingAssistantResult? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        return WritingAssistantResult(body: body)
    }
}

// MARK: Public
extension WritingAssistantResult.Response {
    static func map(content: [String: Any]) -> WritingAssistantResult.Response? {
        guard
            let body = content["body"] as? String,
            let explanation = content["explanation"] as? String,
            let recommendation = content["recommendation"] as? String
        else { return nil }
        
        return WritingAssistantResult.Response(
            userRawInput: content["user_raw_input"] as? String,
            body: body,
            explanation: explanation,
            recommendation: recommendation
        )
    }
}
