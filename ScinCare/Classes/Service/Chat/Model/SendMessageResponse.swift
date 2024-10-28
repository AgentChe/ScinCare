//
//  SendMessageResponse.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

struct SendMessageResponse {
    let message: ChatMessage
    let runner: ChatMessageRunner
}

// MARK: Public
extension SendMessageResponse {
    init?(response: Any) {
        guard
            let jsonOutput = response as? [String: Any],
            let output = jsonOutput["output"] as? String,
            let jsonData = XOREncryption.toJSON(output, key: GlobalDefinitions.XORKey),
            let body = jsonData["body"] as? [String: Any],
            let messageJSON = body["user"] as? [String: Any],
            let message = ChatMessage(json: messageJSON),
            let runnerJSON = body["runner"] as? [String: Any],
            let runner = ChatMessageRunner(json: runnerJSON)
        else { return nil }
        
        self.message = message
        self.runner = runner
    }
}
