//
//  CMRViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 11.11.2024.
//

import RxSwift
import RxCocoa

final class CMRViewModel {
    enum Route {
        case back
        case close
    }
}

// MARK: Public
extension CMRViewModel {
    struct Input {
        let didTapBack: Signal<Void>
        let didTapClose: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapBack: input.didTapBack,
                didTapClose: input.didTapClose
            )
        )
    }
}

// MARK: Private
extension CMRViewModel {
    func makeRoute(
        didTapBack: Signal<Void>,
        didTapClose: Signal<Void>
    ) -> Driver<Route> {
        let back = didTapBack
            .map { Route.back }
            .asDriver(onErrorDriveWith: .never())
        
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(back, close)
    }
}
