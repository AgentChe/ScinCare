//
//  SaveAnalyseSetTitleViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 02.11.2024.
//

import UIKit
import RxSwift

final class SaveAnalyseSetTitleViewController: UIViewController {
    enum Result {
        case back
        case complete
    }
    
    struct Input {
        let analyseId: String
        let side: Side
        let area: SkinArea
    }
    
    private lazy var mainView = SaveAnalyseSetTitleView()
    
    private let viewModel: SaveAnalyseSetTitleViewModel
    
    private let complete: (Result) -> Void
    
    private lazy var disposeBag = DisposeBag()
    
    private init(input: Input, complete: @escaping (Result) -> Void) {
        self.viewModel = SaveAnalyseSetTitleViewModel(input: input)
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
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        let output = viewModel.configure(input: SaveAnalyseSetTitleViewModel.Input(
            didTapBack: mainView.backButton.rx.tap.asSignal(),
            text: mainView.inputField.text,
            didTapSave: mainView.saveButton.rx.tap.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.canSave
            .drive(Binder(mainView) { base, canSave in
                base.saveButton(enable: canSave)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                base.saveButton.isHidden = activity
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.scannedArea
            .drive(Binder(mainView) { base, scannedArea in
                let (side, area) = scannedArea
                
                base.scannedAreaView.setup(side: side, area: area)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SaveAnalyseSetTitleViewController {
    static func make(input: Input, complete: @escaping (Result) -> Void) -> SaveAnalyseSetTitleViewController {
        let vc = SaveAnalyseSetTitleViewController(input: input, complete: complete)
        vc.modalPresentationStyle = .fullScreen
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SaveAnalyseSetTitleViewController {
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func route(_ route: SaveAnalyseSetTitleViewModel.Route) {
        switch route {
        case .back:
            complete(.back)
        case .complete:
            complete(.complete)
        }
    }
}
