//
//  SaveAnalyseSelectSkinAreaViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 02.11.2024.
//

import RxSwift
import RxCocoa

final class SaveAnalyseSelectSkinAreaViewModel {
    enum Route {
        case back
        case next(SaveAnalyseSelectSkinAreaViewController.Output)
    }
    
    private let analyseId: Driver<String>
    
    init(analyseId: String) {
        self.analyseId = BehaviorRelay(value: analyseId).asDriver()
    }
}

// MARK: Public
extension SaveAnalyseSelectSkinAreaViewModel {
    struct Input {
        let didTapBack: Signal<Void>
        let didChangeSide: Signal<Void>
        let didSelectArea: Signal<SkinArea>
        let didTapContinue: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let side: Driver<Side>
        let skinArea: Driver<SkinArea?>
        let canContinue: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let side = makeSide(didChangeSide: input.didChangeSide)
        let skinArea = makeSkinArea(didSelectArea: input.didSelectArea)
        
        return Output(
            route: makeRoute(
                didTapBack: input.didTapBack,
                didTapContinue: input.didTapContinue,
                analyseId: analyseId,
                side: side,
                skinArea: skinArea
            ),
            side: side,
            skinArea: skinArea,
            canContinue: makeCanContinue(skinArea: skinArea)
        )
    }
}

// MARK: Private
private extension SaveAnalyseSelectSkinAreaViewModel {
    func makeRoute(
        didTapBack: Signal<Void>,
        didTapContinue: Signal<Void>,
        analyseId: Driver<String>,
        side: Driver<Side>,
        skinArea: Driver<SkinArea?>
    ) -> Driver<Route> {
        let back = didTapBack
            .map { Route.back }
            .asDriver(onErrorDriveWith: .never())
        
        let next = didTapContinue
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(analyseId)
            .withLatestFrom(side) { ($0, $1) }
            .withLatestFrom(skinArea) { ($0.0, $0.1, $1) }
            .compactMap { args -> Route? in
                let (analyseId, side, skinArea) = args
                
                guard let skinArea else { return nil }
                
                let data = SaveAnalyseSelectSkinAreaViewController.Output(
                    analyseId: analyseId,
                    side: side,
                    area: skinArea
                )
                
                return Route.next(data)
            }
        
        return Driver
            .merge(back, next)
    }
    
    func makeSkinArea(didSelectArea: Signal<SkinArea>) -> Driver<SkinArea?> {
        didSelectArea
            .map { area -> SkinArea? in area }
            .asDriver(onErrorDriveWith: .never())
            .startWith(nil)
    }
    
    func makeSide(didChangeSide: Signal<Void>) -> Driver<Side> {
        didChangeSide
            .scan(.front) { current, next -> Side in
                switch current {
                case .back:
                    return .front
                case .front:
                    return .back
                }
            }
            .startWith(.front)
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeCanContinue(skinArea: Driver<SkinArea?>) -> Driver<Bool> {
        skinArea
            .map { $0 != nil }
    }
}
