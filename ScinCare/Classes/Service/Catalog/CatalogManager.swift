//
//  CatalogManager.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import RxSwift
import RxCocoa

protocol CatalogManagerProtocol {
    func obtainGlossaries(forceUpdate: Bool) -> Single<[Catalog]>
    func obtainProcedures(forceUpdate: Bool) -> Single<[Catalog]>
    func obtainDiseases(forceUpdate: Bool) -> Single<[Catalog]>
    func obtainGlossaryDetails(id: Int) -> Single<CatalogDetails?>
    func obtainProcedureDetails(id: Int) -> Single<CatalogDetails?>
    func obtainDiseaseDetails(id: Int) -> Single<CatalogDetails?>
    func saveGlossary(id: Int) -> Single<Void>
    func saveProcedure(id: Int) -> Single<Void>
    func saveDisease(id: Int) -> Single<Void>
    func unsaveGlossaries(ids: [Int]) -> Single<Void>
    func unsaveProcedures(ids: [Int]) -> Single<Void>
    func unsaveDiseases(ids: [Int]) -> Single<Void>
    func obtainBookmarksGlossaries() -> Single<[Catalog]>
    func obtainBookmarksProcedures() -> Single<[Catalog]>
    func obtainBookmarksDiseases() -> Single<[Catalog]>
}

final class CatalogManager {
    enum Constants {
        static let glossariesKey = "catalog_manager_glossaries_key"
        static let proceduresKey = "catalog_manager_procedures_key"
        static let diseasesKey = "catalog_manager_diseases_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var restAPITransport = RestAPITransport()
}

// MARK: CatalogManagerProtocol
extension CatalogManager: CatalogManagerProtocol {
    func obtainGlossaries(forceUpdate: Bool) -> Single<[Catalog]> {
        if forceUpdate {
            let request = GetGlossariesRequest(userToken: sessionManager.internalId, search: nil)
            return loadCatalogs(request: request, storageKey: Constants.glossariesKey)
        } else {
            return cachedCatalogs(storageKey: Constants.glossariesKey)
        }
    }
    
    func obtainProcedures(forceUpdate: Bool) -> Single<[Catalog]> {
        if forceUpdate {
            let request = GetProceduresRequest(userToken: sessionManager.internalId, search: nil)
            return loadCatalogs(request: request, storageKey: Constants.proceduresKey)
        } else {
            return cachedCatalogs(storageKey: Constants.proceduresKey)
        }
    }
    
    func obtainDiseases(forceUpdate: Bool) -> Single<[Catalog]> {
        if forceUpdate {
            let request = GetDiseasesRequest(userToken: sessionManager.internalId, search: nil)
            return loadCatalogs(request: request, storageKey: Constants.diseasesKey)
        } else {
            return cachedCatalogs(storageKey: Constants.diseasesKey)
        }
    }
    
    func obtainGlossaryDetails(id: Int) -> Single<CatalogDetails?> {
        let request = GetGlossaryDetailsRequest(userToken: sessionManager.internalId, id: id)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { CatalogDetails(response: $0) }
    }
    
    func obtainProcedureDetails(id: Int) -> Single<CatalogDetails?> {
        let request = GetProcedureDetailsRequest(userToken: sessionManager.internalId, id: id)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { CatalogDetails(response: $0) }
    }
    
    func obtainDiseaseDetails(id: Int) -> Single<CatalogDetails?> {
        let request = GetDiseaseDetailsRequest(userToken: sessionManager.internalId, id: id)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { CatalogDetails(response: $0) }
    }
    
    func saveGlossary(id: Int) -> Single<Void> {
        let request = SaveGlossaryRequest(userToken: sessionManager.internalId, id: id)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: {
                CatalogMediator.shared.saveGlossary(id: id)
            })
    }
    
    func saveProcedure(id: Int) -> Single<Void> {
        let request = SaveProcedureRequest(userToken: sessionManager.internalId, id: id)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: {
                CatalogMediator.shared.saveProcedure(id: id)
            })
    }
    
    func saveDisease(id: Int) -> Single<Void> {
        let request = SaveDiseaseRequest(userToken: sessionManager.internalId, id: id)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: {
                CatalogMediator.shared.saveDisease(id: id)
            })
    }
    
    func unsaveGlossaries(ids: [Int]) -> Single<Void> {
        let request = UnsaveGlossaryRequest(userToken: sessionManager.internalId, ids: ids)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: {
                CatalogMediator.shared.unsaveGlossaries(ids: ids)
            })
    }
    
    func unsaveProcedures(ids: [Int]) -> Single<Void> {
        let request = UnsaveProcedureRequest(userToken: sessionManager.internalId, ids: ids)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: {
                CatalogMediator.shared.unsaveProcedures(ids: ids)
            })
    }
    
    func unsaveDiseases(ids: [Int]) -> Single<Void> {
        let request = UnsaveDiseaseRequest(userToken: sessionManager.internalId, ids: ids)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: {
                CatalogMediator.shared.unsaveDiseases(ids: ids)
            })
    }
    
    func obtainBookmarksGlossaries() -> Single<[Catalog]> {
        let request = GetBookmarksGlossariesRequest(userToken: sessionManager.internalId)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Catalog.map(response: $0) }
    }
    
    func obtainBookmarksProcedures() -> Single<[Catalog]> {
        let request = GetBookmarksProceduresRequest(userToken: sessionManager.internalId)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Catalog.map(response: $0) }
    }
    
    func obtainBookmarksDiseases() -> Single<[Catalog]> {
        let request = GetBookmarksDiseasesRequest(userToken: sessionManager.internalId)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Catalog.map(response: $0) }
    }
}

// MARK: Private
private extension CatalogManager {
    func loadCatalogs(request: APIRequestBody, storageKey: String) -> Single<[Catalog]> {
        restAPITransport
            .callServerApi(requestBody: request)
            .map { Catalog.map(response: $0) }
            .do(onSuccess: { catalogs in
                guard let data = try? JSONEncoder().encode(catalogs) else { return }
                
                UserDefaults.standard.set(data, forKey: storageKey)
            })
    }
    
    func cachedCatalogs(storageKey: String) -> Single<[Catalog]> {
        Single<[Catalog]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: storageKey),
                let catalogs = try? JSONDecoder().decode([Catalog].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }

            event(.success(catalogs))

            return Disposables.create()
        }
    }
}
