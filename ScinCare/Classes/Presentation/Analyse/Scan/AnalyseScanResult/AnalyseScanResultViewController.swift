//
//  AnalyseScanResultViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 01.11.2024.
//

import UIKit
import RxSwift

final class AnalyseScanResultViewController: UIViewController {
    enum Result {
        case close
        case save(String)
        case setNotifications(String)
    }
    
    private lazy var mainView = AnalyseScanResultView()
    
    private let viewModel: AnalyseScanResultViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private let complete: (Result) -> Void
    
    private init(image: UIImage, complete: @escaping (Result) -> Void) {
        self.viewModel = AnalyseScanResultViewModel(image: image)
        self.complete = complete
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(analyseId: String, complete: @escaping (Result) -> Void) {
        self.viewModel = AnalyseScanResultViewModel(analyseId: analyseId)
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
        
        let disclaimerTapGesture = UITapGestureRecognizer()
        mainView.disclaimerLabel.isUserInteractionEnabled = true
        mainView.disclaimerLabel.addGestureRecognizer(disclaimerTapGesture)
        
        let output = viewModel.configure(input: AnalyseScanResultViewModel.Input(
            didTapClose: mainView.closeButton.rx.tap.asSignal(),
            didTapDisclaimer: disclaimerTapGesture.rx.event
                .mapToVoid()
                .asSignal(onErrorSignalWith: .never()),
            didTapAction: mainView.actionButton.rx.tap.asSignal()
        ))
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.actionButtonState
            .drive(Binder(mainView) { base, state in
                base.setup(actionButton: state)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension AnalyseScanResultViewController {
    static func make(image: UIImage, complete: @escaping (Result) -> Void) -> AnalyseScanResultViewController {
        let vc = AnalyseScanResultViewController(image: image, complete: complete)
        vc.navigationItem.backButtonTitle = " "
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func make(analyseId: String, complete: @escaping (Result) -> Void) -> AnalyseScanResultViewController {
        let vc = AnalyseScanResultViewController(analyseId: analyseId, complete: complete)
        vc.navigationItem.backButtonTitle = " "
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension AnalyseScanResultViewController {
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
    
    func route(_ route: AnalyseScanResultViewModel.Route) {
        switch route {
        case .close:
            complete(.close)
        case .disclaimer:
            let vc = DisclaimerViewController.make()
            present(vc, animated: true)
        case .save(let analyseId):
            complete(.save(analyseId))
        case .setNotification(let analyseId):
            complete(.setNotifications(analyseId))
        }
    }
}
