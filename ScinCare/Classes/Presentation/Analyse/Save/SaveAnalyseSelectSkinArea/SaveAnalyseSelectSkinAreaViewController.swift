//
//  SaveAnalyseSelectSkinAreaViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 02.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SaveAnalyseSelectSkinAreaViewController: UIViewController {
    enum Result {
        case back
        case output(Output)
    }
    
    struct Output {
        let analyseId: String
        let side: Side
        let area: SkinArea
    }
    
    private lazy var mainView = SaveAnalyseSelectSkinAreaView()
    
    private let viewModel: SaveAnalyseSelectSkinAreaViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private let complete: (Result) -> Void
    
    private init(analyseId: String, complete: @escaping (Result) -> Void) {
        self.viewModel = SaveAnalyseSelectSkinAreaViewModel(analyseId: analyseId)
        self.complete = complete
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SaveAnalyseSelectSkinAreaViewModel.Input(
            didTapBack: mainView.backButton.rx.tap.asSignal(),
            didChangeSide: Signal
                .merge(
                    mainView.leftSideButton.rx.tap.asSignal(),
                    mainView.rightSideButton.rx.tap.asSignal()
                ),
            didSelectArea: mainView.skinAreaView.didSelect,
            didTapContinue: mainView.continueButton.rx.tap.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.side
            .drive(Binder(mainView.skinAreaView) { base, side in
                base.setup(side: side)
            })
            .disposed(by: disposeBag)
        
        output.skinArea
            .drive(Binder(mainView.skinAreaView) { base, skinArea in
                base.setup(skinArea: skinArea)
            })
            .disposed(by: disposeBag)
        
        Driver
            .combineLatest(output.side, output.skinArea)
            .map { ($0, $1) }
            .drive(Binder(mainView) { base, args in
                let (side, skinArea) = args
                
                base.display(side: side, area: skinArea)
            })
            .disposed(by: disposeBag)
        
        output.canContinue
            .drive(Binder(mainView) { base, canContinue in
                base.continueButton(enable: canContinue)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SaveAnalyseSelectSkinAreaViewController {
    static func make(analyseId: String, complete: @escaping (Result) -> Void) -> SaveAnalyseSelectSkinAreaViewController {
        let vc = SaveAnalyseSelectSkinAreaViewController(analyseId: analyseId, complete: complete)
        vc.navigationItem.backButtonTitle = " "
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension SaveAnalyseSelectSkinAreaViewController {
    func route(_ route: SaveAnalyseSelectSkinAreaViewModel.Route) {
        switch route {
        case .back:
            complete(.back)
        case .next(let output):
            complete(.output(output))
        }
    }
}
