//
//  ChatViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import RxSwift
import RxCocoa

final class ChatViewModel {
    enum Route {
        case history
    }
}

// MARK: Public
extension ChatViewModel {
    struct Input {
        let didTapHistory: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(didTapHistory: input.didTapHistory)
        )
    }
}

// MARK: Private
private extension ChatViewModel {
    func makeRoute(didTapHistory: Signal<Void>) -> Driver<Route> {
        didTapHistory
            .map { Route.history }
            .asDriver(onErrorDriveWith: .never())
    }
}
