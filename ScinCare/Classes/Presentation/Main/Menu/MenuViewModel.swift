//
//  MenuViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import RxSwift
import RxCocoa

final class MenuViewModel {
    enum Route {
        case disclaimer
        case open(URL)
    }
}

// MARK: Public
extension MenuViewModel {
    struct Input {
        let didTapMenuRoute: Signal<MenuRouteButton.Route>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(didTapMenuRoute: input.didTapMenuRoute)
        )
    }
}

// MARK: Private
private extension MenuViewModel {
    func makeRoute(didTapMenuRoute: Signal<MenuRouteButton.Route>) -> Driver<Route> {
        let menuRoute = didTapMenuRoute
            .map { menuRoute -> Route in
                switch menuRoute {
                case .disclaimer:
                    return .disclaimer
                case .termsOfUse:
                    return .open(GlobalDefinitions.termsOfServiceUrl)
                case .privacyPolicy:
                    return .open(GlobalDefinitions.privacyPolicyUrl)
                case .support:
                    return .open(GlobalDefinitions.contactUsUrl)
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(menuRoute)
    }
}
