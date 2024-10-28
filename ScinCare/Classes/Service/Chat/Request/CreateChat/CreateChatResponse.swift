//
//  CreateChatResponse.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

enum CreateChatResponse {
    static func map(response: Any) -> String? {
        guard
            let jsonOutput = response as? [String: Any],
            let output = jsonOutput["output"] as? String,
            let jsonData = XOREncryption.toJSON(output, key: GlobalDefinitions.XORKey),
            let body = jsonData["body"] as? [String: Any]
        else { return nil }
        
        return body["thread_id"] as? String
    }
}
