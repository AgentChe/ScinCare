//
//  CatalogMediator.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import RxSwift
import RxCocoa

final class CatalogMediator {
    static let shared = CatalogMediator()
    
    private lazy var didSaveGlossaryIdTrigger = PublishRelay<Int>()
    private lazy var didUnsaveGlossariesIdsTrigger = PublishRelay<[Int]>()
    private lazy var didSaveProcedureIdTrigger = PublishRelay<Int>()
    private lazy var didUnsaveProceduresIdsTrigger = PublishRelay<[Int]>()
    private lazy var didSaveDiseaseIdTrigger = PublishRelay<Int>()
    private lazy var didUnsaveDiseasesIdsTrigger = PublishRelay<[Int]>()
    
    private init() {}
}

// MARK: Public
extension CatalogMediator {
    func saveGlossary(id: Int) {
        DispatchQueue.main.async {
            Self.shared.didSaveGlossaryIdTrigger.accept(id)
        }
    }
    
    func unsaveGlossaries(ids: [Int]) {
        DispatchQueue.main.async {
            Self.shared.didUnsaveGlossariesIdsTrigger.accept(ids)
        }
    }
    
    func saveProcedure(id: Int) {
        DispatchQueue.main.async {
            Self.shared.didSaveProcedureIdTrigger.accept(id)
        }
    }
    
    func unsaveProcedures(ids: [Int]) {
        DispatchQueue.main.async {
            Self.shared.didUnsaveProceduresIdsTrigger.accept(ids)
        }
    }
    
    func saveDisease(id: Int) {
        DispatchQueue.main.async {
            Self.shared.didSaveDiseaseIdTrigger.accept(id)
        }
    }
    
    func unsaveDiseases(ids: [Int]) {
        DispatchQueue.main.async {
            Self.shared.didUnsaveDiseasesIdsTrigger.accept(ids)
        }
    }
    
    var didSaveGlossaryId: Signal<Int> {
        didSaveGlossaryIdTrigger.asSignal()
    }
    
    var didUnsaveGlossariesIds: Signal<[Int]> {
        didUnsaveGlossariesIdsTrigger.asSignal()
    }
    
    var didSaveProcedureId: Signal<Int> {
        didSaveProcedureIdTrigger.asSignal()
    }
    
    var didUnsaveProceduresIds: Signal<[Int]> {
        didUnsaveProceduresIdsTrigger.asSignal()
    }
    
    var didSaveDiseaseId: Signal<Int> {
        didSaveDiseaseIdTrigger.asSignal()
    }
    
    var didUnsaveDiseasesIds: Signal<[Int]> {
        didUnsaveDiseasesIdsTrigger.asSignal()
    }
}
