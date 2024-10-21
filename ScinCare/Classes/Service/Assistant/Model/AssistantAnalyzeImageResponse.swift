//
//  AssistantAnalyzeImageResult.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import Foundation

struct AssistantAnalyzeImageResult {
    let threadId: String
    let url: URL
}

// MARK: Public
extension AssistantAnalyzeImageResult {
    static func map(response: Data?) -> AssistantAnalyzeImageResult? {
        guard
            let response,
            let json = try? JSONSerialization.jsonObject(with: response, options: .allowFragments) as? [String: Any],
            let body = json["body"] as? [String: Any],
            let threadId = body["thread_id"] as? String,
            let path = body["data"] as? String,
            let url = URL(string: path)
        else { return nil }
        
        return AssistantAnalyzeImageResult(threadId: threadId, url: url)
    }
}
