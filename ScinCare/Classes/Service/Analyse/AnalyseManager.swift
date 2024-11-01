//
//  AnalyseManager.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import RxSwift
import RxCocoa

protocol AnalyseManagerProtocol {
    func checkCorrectImage(image: UIImage) -> Single<AnalyseCheckCorrentImage?>
    func getAnalyseResult(analyseId: String) -> Single<AnalyseScanResult?>
    func analyseScan(image: UIImage) -> Single<AnalyseScanResult?>
    func saveScanResult(analyseId: String, title: String, area: [String]) -> Single<Void>
    func obtainHistory() -> Single<[AnalyseScanTemplate]?>
}

final class AnalyseManager {
    private lazy var sessionManager = SessionManager()
    
    private lazy var restAPITransport = RestAPITransport()
}

// MARK: AnalyzeManagerProtocol
extension AnalyseManager: AnalyseManagerProtocol {
    func checkCorrectImage(image: UIImage) -> Single<AnalyseCheckCorrentImage?> {
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = AnalyseCheckCorrectImageRequest(
            anonymousId: anonymousId,
            internalId: (internalId == anonymousId) ? nil : internalId,
            image: image
        )
        
        return restAPITransport
            .callServerApi(formDataBody: request)
            .map { AnalyseCheckCorrentImage(response: $0) }
    }
    
    func getAnalyseResult(analyseId: String) -> Single<AnalyseScanResult?> {
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = GetAnalyseScanResultRequest(
            anonymousId: anonymousId,
            internalId: (internalId == anonymousId) ? nil : internalId,
            analyseId: analyseId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { AnalyseScanResult(response: $0) }
    }
    
    func analyseScan(image: UIImage) -> Single<AnalyseScanResult?> {
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = AnalyseScanImageRequest(
            anonymousId: anonymousId,
            internalId: (internalId == anonymousId) ? nil : internalId,
            image: image
        )
        
        return restAPITransport
            .callServerApi(formDataBody: request)
            .map { AnalyseScanResult(response: $0) }
    }
    
    func saveScanResult(analyseId: String, title: String, area: [String]) -> Single<Void> {
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = AnalyseSaveScanResultRequest(
            anonymousId: anonymousId,
            internalId: (internalId == anonymousId) ? nil : internalId,
            analyseId: analyseId,
            title: title,
            area: area
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func obtainHistory() -> Single<[AnalyseScanTemplate]?> {
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = GetAnalyseHistoryRequest(
            anonymousId: anonymousId,
            internalId: (internalId == anonymousId) ? nil : internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { AnalyseScanTemplate.map(response: $0) }
    }
}
