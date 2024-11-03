//
//  ScanHistoryViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 03.11.2024.
//

import RxSwift
import RxCocoa

final class ScanHistoryViewModel {
    enum Route {
        case back
        case open(String)
    }
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var analyseManager = AnalyseManager()
}

// MARK: Public
extension ScanHistoryViewModel {
    struct Input {
        let didTapBack: Signal<Void>
        let didSelect: Signal<AnalyseScanTemplate>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[AnalyseScanTemplate]>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapBack: input.didTapBack,
                didSelect: input.didSelect
            ),
            elements: makeElements(),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension ScanHistoryViewModel {
    func makeRoute(
        didTapBack: Signal<Void>,
        didSelect: Signal<AnalyseScanTemplate>
    ) -> Driver<Route> {
        let back = didTapBack
            .map { Route.back }
            .asDriver(onErrorDriveWith: .never())
        
        let open = didSelect
            .map { Route.open($0.id) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(back, open)
    }
    
    func makeElements() -> Driver<[AnalyseScanTemplate]> {
        analyseManager
            .obtainHistory()
            .map { $0 ?? [] }
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: [])
    }
}
