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
        case open(String)
    }
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var analyseManager = AnalyseManager()
}

// MARK: Public
extension ScanHistoryViewModel {
    struct Input {
        let didSelect: Signal<AnalyseScanTemplate>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[AnalyseScanTemplate]>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(didSelect: input.didSelect),
            elements: makeElements(),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension ScanHistoryViewModel {
    func makeRoute(didSelect: Signal<AnalyseScanTemplate>) -> Driver<Route> {
        let open = didSelect
            .map { Route.open($0.id) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(open)
    }
    
    func makeElements() -> Driver<[AnalyseScanTemplate]> {
        analyseManager
            .obtainHistory()
            .map { $0 ?? [] }
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: [])
    }
}
