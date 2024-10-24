//
//  BookmarksViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

import RxSwift
import RxCocoa

final class BookmarksViewModel {
    enum Route {
        case catalog(CatalogDetailsViewController.Item, Catalog)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var didDeleteTrigger = PublishRelay<Bool>()
    
    private lazy var catalogManager = CatalogManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension BookmarksViewModel {
    struct Input {
        let didTapFilter: Signal<BookmarksFilterView.Filter>
        let didTapDone: Signal<Void>
        let didTapEdit: Signal<Void>
        let didTapDelete: Signal<Void>
        let didTapCatalog: Signal<Catalog>
    }
    
    struct Output {
        let isEmpty: Driver<BookmarksEmptyView.Unit?>
        let navigationMode: Driver<BookmarksViewController.NavigationMode>
        let elements: Driver<[BookmarksTableElement]>
        let activity: Driver<Bool>
        let hasSelectedOnCurrentFilter: Driver<Bool>
        let route: Driver<Route>
        let disposable: Disposable
    }
    
    func configure(input: Input) -> Output {
        let filter = input
            .didTapFilter
            .startWith(.procedures)
            .asDriver(onErrorDriveWith: .never())
        let navigationMode = makeNavigationMode(
            didTapDone: input.didTapDone,
            didTapEdit: input.didTapEdit,
            didDelete: didDeleteTrigger.asSignal()
        )
        let selectedProcedures = makeSelectedProcedures(
            navigationMode: navigationMode,
            didTapCatalog: input.didTapCatalog,
            filter: filter
        )
        let selectedDiseases = makeSelectedDiseases(
            navigationMode: navigationMode,
            didTapCatalog: input.didTapCatalog,
            filter: filter
        )
        let selectedGlossaries = makeSelectedGlossaries(
            navigationMode: navigationMode,
            didTapCatalog: input.didTapCatalog,
            filter: filter
        )
        let proceduresElements = makeProceduresElements(
            navigationMode: navigationMode,
            bookmarksProcedures: makeBookmarkProcedures(),
            selectedProcedures: selectedProcedures
        )
        let diseasesElements = makeDiseasesElements(
            navigationMode: navigationMode,
            bookmarksDiseases: makeBookmarkDiseases(),
            selectedDiseases: selectedDiseases
        )
        let glossariesElements = makeGlossariesElements(
            navigationMode: navigationMode,
            bookmarksGlossaries: makeBookmarkGlossaries(),
            selectedGlossaries: selectedGlossaries
        )
        let route = makeRoute(
            navigationMode: navigationMode,
            didTapCatalog: input.didTapCatalog,
            filter: filter
        )
        let didDelete = makeDelete(
            filter: filter,
            didTapDelete: input.didTapDelete,
            selectedProcedures: selectedProcedures,
            selectedDiseases: selectedDiseases,
            selectedGlossaries: selectedGlossaries
        )
        let disposable = didDelete
            .asSignal(onErrorSignalWith: .never())
            .emit(to: didDeleteTrigger)
        
        return Output(
            isEmpty: makeIsEmpty(
                filter: filter,
                proceduresElements: proceduresElements,
                diseasesElements: diseasesElements,
                glossariesElements: glossariesElements
            ),
            navigationMode: navigationMode,
            elements: makeElements(
                filter: filter,
                proceduresElements: proceduresElements,
                diseasesElements: diseasesElements,
                glossariesElements: glossariesElements
            ),
            activity: activity.asDriver(),
            hasSelectedOnCurrentFilter: makeHasSelectedOnCurrentFilter(
                filter: filter,
                selectedProcedures: selectedProcedures,
                selectedDiseases: selectedDiseases,
                selectedGlossaries: selectedGlossaries
            ),
            route: route,
            disposable: disposable
        )
    }
}

// MARK: Private
private extension BookmarksViewModel {
    func makeIsEmpty(
        filter: Driver<BookmarksFilterView.Filter>,
        proceduresElements: Driver<[BookmarksTableElement]>,
        diseasesElements: Driver<[BookmarksTableElement]>,
        glossariesElements: Driver<[BookmarksTableElement]>
    ) -> Driver<BookmarksEmptyView.Unit?> {
        Driver
            .combineLatest(
                filter,
                proceduresElements,
                diseasesElements,
                glossariesElements
            ).map { filter, procedures, diseases, glossaries -> BookmarksEmptyView.Unit? in
                switch filter {
                case .procedures:
                    return procedures.isEmpty ? .procedures : nil
                case .diseases:
                    return diseases.isEmpty ? .diseases : nil
                case .glossaries:
                    return glossaries.isEmpty ? .glossaries : nil
                }
            }
    }
    
    func makeNavigationMode(
        didTapDone: Signal<Void>,
        didTapEdit: Signal<Void>,
        didDelete: Signal<Bool>
    ) -> Driver<BookmarksViewController.NavigationMode> {
        Signal<BookmarksViewController.NavigationMode>
            .merge(
                didTapDone.map { .normal },
                didTapEdit.map { .editable },
                didDelete.flatMapLatest { success in
                    success ? .just(.normal) : .never()
                }
            )
            .startWith(.normal)
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeElements(
        filter: Driver<BookmarksFilterView.Filter>,
        proceduresElements: Driver<[BookmarksTableElement]>,
        diseasesElements: Driver<[BookmarksTableElement]>,
        glossariesElements: Driver<[BookmarksTableElement]>
    ) -> Driver<[BookmarksTableElement]> {
        Driver
            .combineLatest(
                filter,
                proceduresElements,
                diseasesElements,
                glossariesElements
            )
            .map { filter, procedures, diseases, glossaries -> [BookmarksTableElement] in
                switch filter {
                case .procedures:
                    return procedures
                case .diseases:
                    return diseases
                case .glossaries:
                    return glossaries
                }
            }
    }
    
    func makeHasSelectedOnCurrentFilter(
        filter: Driver<BookmarksFilterView.Filter>,
        selectedProcedures: Driver<[Catalog]>,
        selectedDiseases: Driver<[Catalog]>,
        selectedGlossaries: Driver<[Catalog]>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(
                filter,
                selectedProcedures.startWith([]),
                selectedDiseases.startWith([]),
                selectedGlossaries.startWith([])
            )
            .map { filter, procedures, diseases, glossaries -> Bool in
                switch filter {
                case .procedures:
                    return !procedures.isEmpty
                case .diseases:
                    return !diseases.isEmpty
                case .glossaries:
                    return !glossaries.isEmpty
                }
            }
    }
    
    func makeProceduresElements(
        navigationMode: Driver<BookmarksViewController.NavigationMode>,
        bookmarksProcedures: Driver<[Catalog]>,
        selectedProcedures: Driver<[Catalog]>
    ) -> Driver<[BookmarksTableElement]> {
        Driver
            .combineLatest(
                navigationMode,
                bookmarksProcedures,
                selectedProcedures
            )
            .map { mode, bookmarksProcedures, selectedProcedures -> [BookmarksTableElement] in
                bookmarksProcedures.map { procedure -> BookmarksTableElement in
                    BookmarksTableElement(
                        catalog: procedure,
                        selected: mode == .editable ? selectedProcedures.contains(where: { $0.id == procedure.id }) : nil
                    )
                }
            }
    }
    
    func makeDiseasesElements(
        navigationMode: Driver<BookmarksViewController.NavigationMode>,
        bookmarksDiseases: Driver<[Catalog]>,
        selectedDiseases: Driver<[Catalog]>
    ) -> Driver<[BookmarksTableElement]> {
        Driver
            .combineLatest(
                navigationMode,
                bookmarksDiseases,
                selectedDiseases
            )
            .map { mode, bookmarksDiseases, selectedDiseases -> [BookmarksTableElement] in
                bookmarksDiseases.map { disease -> BookmarksTableElement in
                    BookmarksTableElement(
                        catalog: disease,
                        selected: mode == .editable ? selectedDiseases.contains(where: { $0.id == disease.id }) : nil
                    )
                }
            }
    }
    
    func makeGlossariesElements(
        navigationMode: Driver<BookmarksViewController.NavigationMode>,
        bookmarksGlossaries: Driver<[Catalog]>,
        selectedGlossaries: Driver<[Catalog]>
    ) -> Driver<[BookmarksTableElement]> {
        Driver
            .combineLatest(
                navigationMode,
                bookmarksGlossaries,
                selectedGlossaries
            )
            .map { mode, bookmarksGlossaries, selectedGlossaries -> [BookmarksTableElement] in
                bookmarksGlossaries.map { glossary -> BookmarksTableElement in
                    BookmarksTableElement(
                        catalog: glossary,
                        selected: mode == .editable ? selectedGlossaries.contains(where: { $0.id == glossary.id }) : nil
                    )
                }
            }
    }
    
    func makeSelectedProcedures(
        navigationMode: Driver<BookmarksViewController.NavigationMode>,
        didTapCatalog: Signal<Catalog>,
        filter: Driver<BookmarksFilterView.Filter>
    ) -> Driver<[Catalog]> {
        makeSelectedUnits(
            navigationMode: navigationMode,
            didTapCatalog: didTapCatalog
                .asDriver(onErrorDriveWith: .never())
                .withLatestFrom(filter) { ($0, $1) }
                .compactMap { $1 == .procedures ? $0 : nil }
        )
    }
    
    func makeSelectedDiseases(
        navigationMode: Driver<BookmarksViewController.NavigationMode>,
        didTapCatalog: Signal<Catalog>,
        filter: Driver<BookmarksFilterView.Filter>
    ) -> Driver<[Catalog]> {
        makeSelectedUnits(
            navigationMode: navigationMode,
            didTapCatalog: didTapCatalog
                .asDriver(onErrorDriveWith: .never())
                .withLatestFrom(filter) { ($0, $1) }
                .compactMap { $1 == .diseases ? $0 : nil }
        )
    }
    
    func makeSelectedGlossaries(
        navigationMode: Driver<BookmarksViewController.NavigationMode>,
        didTapCatalog: Signal<Catalog>,
        filter: Driver<BookmarksFilterView.Filter>
    ) -> Driver<[Catalog]> {
        makeSelectedUnits(
            navigationMode: navigationMode,
            didTapCatalog: didTapCatalog
                .asDriver(onErrorDriveWith: .never())
                .withLatestFrom(filter) { ($0, $1) }
                .compactMap { $1 == .glossaries ? $0 : nil }
        )
    }
    
    func makeSelectedUnits(
        navigationMode: Driver<BookmarksViewController.NavigationMode>,
        didTapCatalog: Driver<Catalog>
    ) -> Driver<[Catalog]> {
        navigationMode
            .flatMapLatest { mode -> Driver<[Catalog]> in
                switch mode {
                case .editable:
                    return didTapCatalog
                        .scan([]) { array, catalog -> [Catalog] in
                            if let index = array.firstIndex(where: { $0.id == catalog.id }) {
                                var result = array
                                result.remove(at: index)
                                return result
                            } else {
                                return array + [catalog]
                            }
                        }
                        .startWith([])
                        .asDriver(onErrorJustReturn: [])
                case .normal:
                    return .just([])
                }
            }
    }
    
    func makeBookmarkProcedures() -> Driver<[Catalog]> {
        makeUnits(
            downloadTrigger: CatalogMediator.shared
                .didSaveProcedureId
                .map { id in Void() },
            removeTrigger: CatalogMediator.shared
                .didUnsaveProceduresIds,
            source: { [weak self] in
                guard let self = self else {
                    return .never()
                }
                
                return self.catalogManager
                    .obtainBookmarksProcedures()
            }
        )
    }
    
    func makeBookmarkDiseases() -> Driver<[Catalog]> {
        makeUnits(
            downloadTrigger: CatalogMediator.shared
                .didSaveDiseaseId
                .map { id in Void() },
            removeTrigger: CatalogMediator.shared
                .didUnsaveDiseasesIds,
            source: { [weak self] in
                guard let self = self else {
                    return .never()
                }
                
                return self.catalogManager
                    .obtainBookmarksDiseases()
            }
        )
    }
    
    func makeBookmarkGlossaries() -> Driver<[Catalog]> {
        makeUnits(
            downloadTrigger: CatalogMediator.shared
                .didSaveGlossaryId
                .map { id in Void() },
            removeTrigger: CatalogMediator.shared
                .didUnsaveGlossariesIds,
            source: { [weak self] in
                guard let self = self else {
                    return .never()
                }
                
                return self.catalogManager
                    .obtainBookmarksGlossaries()
            }
        )
    }
    
    func makeUnits(
        downloadTrigger: Signal<Void>,
        removeTrigger: Signal<[Int]>,
        source: @escaping () -> Single<[Catalog]>
    ) -> Driver<[Catalog]> {
        let download = downloadTrigger
            .map { id in Void() }
            .startWith(Void())
            .flatMapLatest { [weak self] void -> Driver<[Catalog]> in
                guard let self = self else {
                    return .never()
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return download
            .flatMapLatest { units -> Driver<[Catalog]> in
                removeTrigger
                    .startWith([])
                    .asDriver(onErrorJustReturn: [])
                    .scan(units) { array, ids -> [Catalog] in
                        guard !ids.isEmpty else {
                            return array
                        }
                        
                        var result = array
                        result.removeAll(where: { catalog -> Bool in
                            ids.contains(where: { $0 == catalog.id })
                        })
                        
                        return result
                    }
            }
    }
    
    func makeRoute(
        navigationMode: Driver<BookmarksViewController.NavigationMode>,
        didTapCatalog: Signal<Catalog>,
        filter: Driver<BookmarksFilterView.Filter>
    ) -> Driver<Route> {
        didTapCatalog
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(filter) { ($0, $1) }
            .withLatestFrom(navigationMode) { ($0.0, $0.1, $1) }
            .compactMap { args -> Route? in
                let (catalog, filter, navigationMode) = args
                
                guard navigationMode == .normal else { return nil }
                
                switch filter {
                case .procedures:
                    return (.catalog(.procedure, catalog))
                case .diseases:
                    return (.catalog(.disease, catalog))
                case .glossaries:
                    return (.catalog(.glossary, catalog))
                }
            }
    }
    
    func makeDelete(
        filter: Driver<BookmarksFilterView.Filter>,
        didTapDelete: Signal<Void>,
        selectedProcedures: Driver<[Catalog]>,
        selectedDiseases: Driver<[Catalog]>,
        selectedGlossaries: Driver<[Catalog]>
    ) -> Driver<Bool> {
        let filter = didTapDelete
            .withLatestFrom(filter)
            .asDriver(onErrorDriveWith: .never())

        let selected = Driver
            .combineLatest(
                selectedProcedures.startWith([]),
                selectedDiseases.startWith([]),
                selectedGlossaries.startWith([])
            )
        
        return filter
            .withLatestFrom(selected) { ($0, $1) }
            .flatMapLatest { [weak self] filter, args -> Driver<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                let (procedures, diseases, glossaries) = args
                
                func source() -> Single<Void> {
                    switch filter {
                    case .procedures:
                        return self.catalogManager
                            .unsaveProcedures(ids: procedures.map { $0.id })
                    case .diseases:
                        return self.catalogManager
                            .unsaveDiseases(ids: diseases.map { $0.id })
                    case .glossaries:
                        return self.catalogManager
                            .unsaveGlossaries(ids: glossaries.map { $0.id })
                    }
                }
                    
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .map { true }
                    .asDriver(onErrorJustReturn: false)
            }
    }
}
