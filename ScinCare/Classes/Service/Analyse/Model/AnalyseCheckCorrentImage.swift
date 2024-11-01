//
//  AnalyseCheckCorrentImage.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

struct AnalyseCheckCorrentImage {
    let correct: Bool
}

// MARK: Public
extension AnalyseCheckCorrentImage {
    init?(response: Any) {
        guard
            let jsonOutput = response as? [String: Any],
            let output = jsonOutput["output"] as? String,
            let jsonData = XOREncryption.toJSON(output, key: GlobalDefinitions.XORKey),
            let body = jsonData["body"] as? [String: Any],
            let correct = body["correct"] as? Bool
        else { return nil }
        
        self.correct = correct
    }
}
