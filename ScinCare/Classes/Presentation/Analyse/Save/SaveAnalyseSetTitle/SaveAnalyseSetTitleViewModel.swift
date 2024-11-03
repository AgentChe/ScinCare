//
//  SaveAnalyseSetTitleViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 02.11.2024.
//

import RxSwift
import RxCocoa

final class SaveAnalyseSetTitleViewModel {
    enum Route {
        case back
        case complete
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let inputData: Driver<SaveAnalyseSetTitleViewController.Input>
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var analyseManager = AnalyseManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(input: SaveAnalyseSetTitleViewController.Input) {
        self.inputData = BehaviorRelay(value: input).asDriver()
    }
}

// MARK: Public
extension SaveAnalyseSetTitleViewModel {
    struct Input {
        let didTapBack: Signal<Void>
        let text: Signal<String>
        let didTapSave: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let canSave: Driver<Bool>
        let activity: Driver<Bool>
        let scannedArea: Driver<(Side, SkinArea)>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapBack: input.didTapBack,
                text: input.text,
                didTapSave: input.didTapSave,
                inputData: inputData
            ),
            canSave: makeCanSave(text: input.text),
            activity: activity.asDriver(),
            scannedArea: inputData.map { ($0.side, $0.area) }
        )
    }
}

// MARK: Private
private extension SaveAnalyseSetTitleViewModel {
    func makeRoute(
        didTapBack: Signal<Void>,
        text: Signal<String>,
        didTapSave: Signal<Void>,
        inputData: Driver<SaveAnalyseSetTitleViewController.Input>
    ) -> Driver<Route> {
        let back = didTapBack
            .map { Route.back }
            .asDriver(onErrorDriveWith: .never())
        
        let complete = didTapSave
            .withLatestFrom(text)
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(inputData) { ($0, $1) }
            .flatMapLatest { [weak self] args -> Driver<Route> in
                guard let self else { return .never() }
                
                let (text, inputData) = args
                
                func source() -> Single<Route> {
                    analyseManager
                        .saveScanResult(
                            analyseId: inputData.analyseId,
                            title: text,
                            area: [inputData.side.localized, inputData.area.localized]
                        )
                        .map { Route.complete }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }

                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(activity)
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(back, complete)
    }
    
    func makeCanSave(text: Signal<String>) -> Driver<Bool> {
        text
            .startWith("")
            .map { !$0.isEmpty }
            .asDriver(onErrorDriveWith: .never())
    }
}
