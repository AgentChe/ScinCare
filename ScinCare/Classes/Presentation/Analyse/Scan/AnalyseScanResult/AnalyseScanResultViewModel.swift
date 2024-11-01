//
//  AnalyseScanResultViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 01.11.2024.
//

import RxSwift
import RxCocoa

final class AnalyseScanResultViewModel {
    enum Route {
        case close
        case disclaimer
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let source: Driver<Source>
    
    init(image: UIImage) {
        source = BehaviorRelay(value: .scanImage(image)).asDriver()
    }
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var analyseManager = AnalyseManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension AnalyseScanResultViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapDisclaimer: Signal<Void>
    }
    
    struct Output {
        let activity: Driver<Bool>
        let saveButtonHidden: Driver<Bool>
        let elements: Driver<[AnalyseScanResultTableElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let scanResult = makeScanResult(source: source)
        
        return Output(
            activity: activity.asDriver(),
            saveButtonHidden: makeSaveButtonHidden(scanResult: scanResult),
            elements: makeElements(scanResult: scanResult),
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapDisclaimer: input.didTapDisclaimer
            )
        )
    }
}

// MARK: Private
private extension AnalyseScanResultViewModel {
    enum Source {
        case scanImage(UIImage)
    }
    
    func makeElements(scanResult: Driver<AnalyseScanResult>) -> Driver<[AnalyseScanResultTableElement]> {
        scanResult
            .map { scanResult -> [AnalyseScanResultTableElement] in
                var result: [AnalyseScanResultTableElement] = [
                    .image(scanResult.image),
                    .name(scanResult.name),
                ]
                
                if let assessment = scanResult.assessment {
                    result.append(.assessment(assessment))
                }
                if let conclusion = scanResult.conclusion {
                    result.append(.conclusion(conclusion))
                }
                if let recommendations = scanResult.recommendations {
                    result.append(.recommendations(recommendations))
                }
                if let description = scanResult.description {
                    result.append(.description(description))
                }
                
                return result
            }
    }
    
    func makeSaveButtonHidden(scanResult: Driver<AnalyseScanResult>) -> Driver<Bool> {
        scanResult
            .map { $0.saved }
    }
    
    func makeScanResult(source: Driver<Source>) -> Driver<AnalyseScanResult> {
        source
            .flatMapLatest { [weak self] dataSource -> Driver<AnalyseScanResult> in
                guard let self else { return .never() }
                
                func source() -> Single<AnalyseScanResult> {
                    switch dataSource {
                    case .scanImage(let image):
                        return analyseManager
                            .analyseScan(image: image)
                            .map { result -> AnalyseScanResult in
                                guard let result else {
                                    throw ContentError(.notContent)
                                }
                                
                                return result
                            }
                    }
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
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapDisclaimer: Signal<Void>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let disclaimer = didTapDisclaimer
            .map { Route.disclaimer }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, disclaimer)
    }
}
