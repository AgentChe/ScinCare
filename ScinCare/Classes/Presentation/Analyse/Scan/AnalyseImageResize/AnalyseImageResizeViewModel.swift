//
//  AnalyseImageResizeViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import RxSwift
import RxCocoa

final class AnalyseImageResizeViewModel {
    enum Route {
        case back
        case retake
        case finish(UIImage)
    }
    
    enum Action {
        case crop
        case changeOptionsState(AnalyseImageResizeOptionsView.State)
    }
    
    private lazy var analyseManager = AnalyseManager()
}

// MARK: Public
extension AnalyseImageResizeViewModel {
    struct Input {
        let didTapBack: Signal<Void>
        let didAcceptPhoto: Signal<Void>
        let didRetakePhoto: Signal<Void>
        let didContinue: Signal<Void>
        let pushCroppedImage: Signal<UIImage>
    }
    
    struct Output {
        let route: Driver<Route>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let optionsState = makeOptionsState(pushCroppedImage: input.pushCroppedImage)
        
        return Output(
            route: makeRoute(
                didTapBack: input.didTapBack,
                didRetakePhoto: input.didRetakePhoto,
                didContinue: input.didContinue,
                pushCroppedImage: input.pushCroppedImage
            ),
            action: makeAction(
                didAcceptPhoto: input.didAcceptPhoto,
                optionsState: optionsState
            )
        )
    }
}

// MARK: Private
private extension AnalyseImageResizeViewModel {
    func makeRoute(
        didTapBack: Signal<Void>,
        didRetakePhoto: Signal<Void>,
        didContinue: Signal<Void>,
        pushCroppedImage: Signal<UIImage>
    ) -> Driver<Route> {
        let back = didTapBack
            .map { Route.back }
            .asDriver(onErrorDriveWith: .never())
        
        let retake = didRetakePhoto
            .map { Route.retake }
            .asDriver(onErrorDriveWith: .never())
        
        let finish = didContinue
            .withLatestFrom(pushCroppedImage)
            .map { Route.finish($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(back, retake, finish)
    }
    
    func makeAction(
        didAcceptPhoto: Signal<Void>,
        optionsState: Driver<AnalyseImageResizeOptionsView.State>
    ) -> Driver<Action> {
        let crop = didAcceptPhoto
            .map { Action.crop }
            .asDriver(onErrorDriveWith: .never())
        
        let changedOptionsState = optionsState
            .map { Action.changeOptionsState($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(crop, changedOptionsState)
    }
    
    func makeOptionsState(pushCroppedImage: Signal<UIImage>) -> Driver<AnalyseImageResizeOptionsView.State> {
        pushCroppedImage
            .flatMapLatest { [weak self] image -> Driver<AnalyseImageResizeOptionsView.State> in
                guard let self else { return .never() }
                
                return analyseManager
                    .checkCorrectImage(image: image)
                    .asDriver(onErrorJustReturn: nil)
                    .map { $0?.correct == true ? .correct : .incorrect }
                    .startWith(.preloader)
            }
            .startWith(.acceptPhoto)
    }
}
