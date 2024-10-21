//
//  WritingStyle.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

enum WritingStyle: CaseIterable {
    case expository
    case narrative
    case argumentative
    case analytical
    case research
    case descriptive
    case omparative
    case other
    
    init?(meta: String) {
        switch meta.lowercased() {
        case "expository":
            self = .expository
        case "narrative":
            self = .narrative
        case "argumentative":
            self = .argumentative
        case "analytical":
            self = .analytical
        case "research":
            self = .research
        case "descriptive":
            self = .descriptive
        case "omparative":
            self = .omparative
        case "other":
            self = .other
        default:
            return nil
        }
    }
}
