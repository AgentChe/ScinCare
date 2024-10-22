//
//  CatalogsViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import RxSwift
import RxCocoa

final class CatalogsViewModel {
    enum Route {
        case back
        case details(CatalogsTableElement)
    }
    
    private let item: Driver<CatalogsViewController.Item>
    
    private lazy var catalogManager = CatalogManager()
    
    init(item: CatalogsViewController.Item) {
        self.item = BehaviorRelay(value: item).asDriver()
    }
}

// MARK: Public
extension CatalogsViewModel {
    struct Input {
        let didTapBack: Signal<Void>
        let didSearch: Signal<String>
        let didSelect: Signal<CatalogsTableElement>
    }
    
    struct Output {
        let elements: Driver<[CatalogsTableElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(
                activeSubscription: makeActiveSubscription(),
                catalogs: makeCatalogs(),
                didSearch: input.didSearch
            ),
            route: makeRoute(
                didTapBack: input.didTapBack,
                didSelect: input.didSelect
            )
        )
    }
}

// MARK: Private
private extension CatalogsViewModel {
    func makeElements(
        activeSubscription: Driver<Bool>,
        catalogs: Driver<[Catalog]>,
        didSearch: Signal<String>
    ) -> Driver<[CatalogsTableElement]> {
        Driver
            .combineLatest(
                activeSubscription,
                catalogs,
                didSearch.asDriver(onErrorDriveWith: .never())
            )
            .map { activeSubscription, catalogs, search -> [CatalogsTableElement] in
                var array = catalogs
                
                if !search.isEmpty {
                    array = array.filter { catalog -> Bool in
                        catalog.name.contains(search)
                    }
                }
                
                return array.enumerated().map { index, catalog -> CatalogsTableElement in
                    CatalogsTableElement(
                        catalog: catalog,
                        locked: (index >= 3) ? !activeSubscription : false
                    )
                }
            }
    }
    
    func makeCatalogs() -> Driver<[Catalog]> {
        item
            .flatMapLatest { [weak self] item -> Driver<[Catalog]> in
                guard let self else { return .never() }
                
                switch item {
                case .glossary:
                    return catalogManager
                        .obtainGlossaries(forceUpdate: false)
                        .asDriver(onErrorJustReturn: [])
                case .procedure:
                    return catalogManager
                        .obtainProcedures(forceUpdate: false)
                        .asDriver(onErrorJustReturn: [])
                case .disease:
                    return catalogManager
                        .obtainDiseases(forceUpdate: false)
                        .asDriver(onErrorJustReturn: [])
                }
            }
    }
    
    func makeRoute(
        didTapBack: Signal<Void>,
        didSelect: Signal<CatalogsTableElement>
    ) -> Driver<Route> {
        let back = didTapBack
            .map { Route.back }
            .asDriver(onErrorDriveWith: .never())
        
        let details = didSelect
            .map { Route.details($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(back, details)
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { SessionManager().hasActiveSubscriptions() }
            .startWith(SessionManager().hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}
