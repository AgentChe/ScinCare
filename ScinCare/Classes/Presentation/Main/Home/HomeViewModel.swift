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
    }
}

// MARK: Public
extension HomeViewModel {
    struct Input {
        let didTapMenu: Signal<Void>
        let didTapExplore: Signal<HomeExploreItemButton.Item>
    }
    
    struct Output {
        let elements: Driver<[HomeCollectionElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(),
            route: makeRoute(
                didTapMenu: input.didTapMenu,
                didTapExplore: input.didTapExplore
            )
        )
    }
}

// MARK: Private
private extension HomeViewModel {
    func makeElements() -> Driver<[HomeCollectionElement]> {
        .deferred {
            .just([
                HomeCollectionElement.explore
            ])
        }
    }
    
    func makeRoute(
        didTapMenu: Signal<Void>,
        didTapExplore: Signal<HomeExploreItemButton.Item>
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
        
        return Driver
            .merge(menu, catalogs)
    }
}
