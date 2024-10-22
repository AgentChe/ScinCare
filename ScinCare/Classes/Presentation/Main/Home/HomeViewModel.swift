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
            route: makeRoute(didTapMenu: input.didTapMenu)
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
    
    func makeRoute(didTapMenu: Signal<Void>) -> Driver<Route> {
        let menu = didTapMenu
            .map { Route.menu }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(menu)
    }
}
