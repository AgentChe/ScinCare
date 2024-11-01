//
//  AnalyseScanResultTableElement.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 01.11.2024.
//

import Foundation

enum AnalyseScanResultTableElement {
    case image(URL)
    case name(String)
    case assessment(AnalyseScanAssessment)
    case conclusion(AnalyseScanConclusion)
    case recommendations([AnalyseScanRecommendation])
    case description(String)
}
