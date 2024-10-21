//
//  AssistantManager.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 09.09.2024.
//

import RxSwift
import RxCocoa

protocol AssistantManagerProtocol {
    func analyze(image: UIImage, assistantType: AssistantAnalyzeImage.AssistantType) -> Single<AssistantAnalyzeImageResult?>
    func analyzeManualMath(text: String) -> Single<MathAssistantResult?>
    func processMath(threadId: String, isRepeat: Bool) -> Single<MathAssistantResult?>
    func analyzeManualPhysics(text: String) -> Single<PhysicsAssistantResult?>
    func processPhysics(threadId: String, isRepeat: Bool) -> Single<PhysicsAssistantResult?>
    func analyzeManualBiology(text: String) -> Single<BiologyAssistantResult?>
    func processBiology(threadId: String, isRepeat: Bool) -> Single<BiologyAssistantResult?>
    func analyzeManualChemistry(text: String) -> Single<ChemistryAssistantResult?>
    func processChemistry(threadId: String, isRepeat: Bool) -> Single<ChemistryAssistantResult?>
    
    func analyzeWriting(image: UIImage, mode: WritingMode, style: WritingStyle) -> Single<AssistantAnalyzeImageResult?>
    func analyzeManualWriting(text: String, mode: WritingMode, style: WritingStyle) -> Single<WritingAssistantResult?>
    func processWriting(threadId: String, isRepeat: Bool) -> Single<WritingAssistantResult?>
    
    func translate(image: UIImage, languageCode: String) -> Single<TranslateResult?>
    func translate(text: String, languageCode: String) -> Single<TranslateResult?>
    
    func helpful(threadId: String, assistantType: AssistantHelpfulRequest.AssistantType, helpful: Bool) -> Single<Void>
    
    func obtainLanaguages(forceUpdate: Bool) -> Single<[Language]>
    
    func history(page: Int) -> Single<AssistantHistoryPage?>
}

final class AssistantManager {
    enum Constants {
        static let languages = "assistant_manager_languages_key"
    }
    
    private lazy var analyzeImage = AssistantAnalyzeImage()
    private lazy var translateImage = AssistantTranslateImage()
    private lazy var analyzeWritingImage = AssistantAnalyzeWritingImage()
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
}

// MARK: AssistantManagerProtocol
extension AssistantManager: AssistantManagerProtocol {
    func analyze(image: UIImage, assistantType: AssistantAnalyzeImage.AssistantType) -> Single<AssistantAnalyzeImageResult?> {
        Single<AssistantAnalyzeImageResult?>.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            analyzeImage.upload(image: image, assistantType: assistantType) { result in
                single(.success(result))
            }
            
            return Disposables.create()
        }
    }
    
    func analyzeManualMath(text: String) -> Single<MathAssistantResult?> {
        let request = AssistantAnalyzeManualRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            assistantType: .math,
            text: text
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { MathAssistantResult.map(response: $0) }
    }
    
    func processMath(threadId: String, isRepeat: Bool) -> Single<MathAssistantResult?> {
        let request = AssistantAnalyzeProcessRequest(
            assistantType: .math,
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            threadId: threadId,
            isRepeat: isRepeat
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { MathAssistantResult.map(response: $0) }
    }
    
    func analyzeManualPhysics(text: String) -> Single<PhysicsAssistantResult?> {
        let request = AssistantAnalyzeManualRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            assistantType: .physics,
            text: text
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { PhysicsAssistantResult.map(response: $0) }
    }
    
    func processPhysics(threadId: String, isRepeat: Bool) -> Single<PhysicsAssistantResult?> {
        let request = AssistantAnalyzeProcessRequest(
            assistantType: .physics,
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            threadId: threadId,
            isRepeat: isRepeat
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { PhysicsAssistantResult.map(response: $0) }
    }
    
    func analyzeManualBiology(text: String) -> Single<BiologyAssistantResult?> {
        let request = AssistantAnalyzeManualRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            assistantType: .biology,
            text: text
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { BiologyAssistantResult.map(response: $0) }
    }
    
    func processBiology(threadId: String, isRepeat: Bool) -> Single<BiologyAssistantResult?> {
        let request = AssistantAnalyzeProcessRequest(
            assistantType: .biology,
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            threadId: threadId,
            isRepeat: isRepeat
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { BiologyAssistantResult.map(response: $0) }
    }
    
    func analyzeManualChemistry(text: String) -> Single<ChemistryAssistantResult?> {
        let request = AssistantAnalyzeManualRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            assistantType: .chemistry,
            text: text
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { ChemistryAssistantResult.map(response: $0) }
    }
    
    func processChemistry(threadId: String, isRepeat: Bool) -> Single<ChemistryAssistantResult?> {
        let request = AssistantAnalyzeProcessRequest(
            assistantType: .chemistry,
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            threadId: threadId,
            isRepeat: isRepeat
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { ChemistryAssistantResult.map(response: $0) }
    }
    
    func analyzeWriting(image: UIImage, mode: WritingMode, style: WritingStyle) -> Single<AssistantAnalyzeImageResult?> {
        Single<AssistantAnalyzeImageResult?>.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            analyzeWritingImage.upload(image: image, mode: mode, style: style) { result in
                single(.success(result))
            }
            
            return Disposables.create()
        }
    }
    
    func analyzeManualWriting(text: String, mode: WritingMode, style: WritingStyle) -> Single<WritingAssistantResult?> {
        let request = AssistantAnalyzeManualWritingRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            text: text,
            mode: mode,
            style: style
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { WritingAssistantResult.map(response: $0) }
    }
    
    func processWriting(threadId: String, isRepeat: Bool) -> Single<WritingAssistantResult?> {
        let request = AssistantAnalyzeWritingProcessRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            threadId: threadId,
            isRepeat: isRepeat
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { WritingAssistantResult.map(response: $0) }
    }
    
    func helpful(threadId: String, assistantType: AssistantHelpfulRequest.AssistantType, helpful: Bool) -> Single<Void> {
        let request = AssistantHelpfulRequest(
            assistantType: assistantType,
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            threadId: threadId,
            helpful: helpful
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func translate(image: UIImage, languageCode: String) -> Single<TranslateResult?> {
        Single<TranslateResult?>.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            translateImage.upload(image: image, languageCode: languageCode) { result in
                single(.success(result))
            }
            
            return Disposables.create()
        }
    }
    
    func translate(text: String, languageCode: String) -> Single<TranslateResult?> {
        let request = AssistantTranslateRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            text: text,
            languageCode: languageCode
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { TranslateResult.map(response: $0) }
    }
    
    func obtainLanaguages(forceUpdate: Bool) -> Single<[Language]> {
        forceUpdate ? downloadLanguages() : cachedLanguages()
    }
    
    func history(page: Int) -> Single<AssistantHistoryPage?> {
        let request = AssistantHistoryRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            page: page
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { AssistantHistoryPage(response: $0) }
    }
}

// MARK: Private
private extension AssistantManager {
    func downloadLanguages() -> Single<[Language]> {
        restApiTransport
            .callServerApi(requestBody: GetLanguagesRequest())
            .map { Language.map(response: $0) }
            .do(onSuccess: { languages in
                if let data = try? JSONEncoder().encode(languages) {
                    UserDefaults.standard.set(data, forKey: Constants.languages)
                }
            })
    }
    
    func cachedLanguages() -> Single<[Language]> {
        Single<[Language]>.create { single in
            let languages: [Language] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.languages) else { return [] }
                
                let languages = try? JSONDecoder().decode([Language].self, from: data)
                return languages ?? []
            }()
            
            single(.success(languages))
            
            return Disposables.create()
        }
    }
}
