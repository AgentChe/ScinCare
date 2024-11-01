//
//  HomeViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 21.10.2024.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
    enum Route {
        case menu
        case catalogs(CatalogsViewController.Item)
        case openScanner
        case openHistory
    }
    
    private lazy var analyseManager = AnalyseManager()
}

// MARK: Public
extension HomeViewModel {
    struct Input {
        let didTapMenu: Signal<Void>
        let didTapExplore: Signal<HomeExploreItemButton.Item>
        let didOpenScanner: Signal<Void>
        let didOpenHistory: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[HomeCollectionElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let hasHistory = makeHasHistory()
        
        return Output(
            elements: makeElements(hasHistory: hasHistory),
            route: makeRoute(
                didTapMenu: input.didTapMenu,
                didTapExplore: input.didTapExplore,
                didOpenScanner: input.didOpenScanner,
                didOpenHistory: input.didOpenHistory
            )
        )
    }
}

// MARK: Private
private extension HomeViewModel {
    func makeElements(hasHistory: Driver<Bool>) -> Driver<[HomeCollectionElement]> {
        hasHistory
            .map { hasHistory -> [HomeCollectionElement] in
                [
                    hasHistory ? .openHistory : .openScanner,
                    .explore
                ]
            }
            .startWith([.explore])
    }
    
    func makeHasHistory() -> Driver<Bool> {
        analyseManager
            .obtainHistory()
            .map { !($0 ?? []).isEmpty }
            .asDriver(onErrorJustReturn: false)
    }
    
    func makeRoute(
        didTapMenu: Signal<Void>,
        didTapExplore: Signal<HomeExploreItemButton.Item>,
        didOpenScanner: Signal<Void>,
        didOpenHistory: Signal<Void>
    ) -> Driver<Route> {
        let menu = didTapMenu
            .map { Route.menu }
            .asDriver(onErrorDriveWith: .never())
        
        let catalogs = didTapExplore
            .map { item -> Route in
                switch item {
                case .glossary:
                    return .catalogs(.glossary)
                case .procedures:
                    return .catalogs(.procedure)
                case .disease:
                    return .catalogs(.disease)
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        let scanner = didOpenScanner
            .map { Route.openScanner }
            .asDriver(onErrorDriveWith: .never())
        
        let history = didOpenHistory
            .map { Route.openHistory }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(menu, catalogs, scanner, history)
    }
}
