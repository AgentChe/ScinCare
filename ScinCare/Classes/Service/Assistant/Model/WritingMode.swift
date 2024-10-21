//
//  WritingMode.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

enum WritingMode {
    case outline, essay
    
    init?(meta: String) {
        switch meta.lowercased() {
        case "essay":
            self = .essay
        case "outline":
            self = .outline
        default:
            return nil
        }
    }
}
