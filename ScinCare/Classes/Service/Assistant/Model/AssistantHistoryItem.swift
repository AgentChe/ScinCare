//
//  AssistantHistoryItem.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 12.09.2024.
//

enum AssistantHistoryItem {
    case math(MathAssistantResult)
    case physics(PhysicsAssistantResult)
    case biology(BiologyAssistantResult)
    case chemistry(ChemistryAssistantResult)
    case writing(WritingAssistantResult)
}
