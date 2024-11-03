//
//  ScanHistoryViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 03.11.2024.
//

import UIKit
import RxSwift

final class ScanHistoryViewController: UIViewController {
    private lazy var mainView = ScanHistoryView()
    
    private lazy var viewModel = ScanHistoryViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: ScanHistoryViewModel.Input(
            didTapBack: mainView.backButton.rx.tap.asSignal(),
            didSelect: mainView.tableView.didSelect
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ScanHistoryViewController {
    static func make() -> ScanHistoryViewController {
        let vc = ScanHistoryViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension ScanHistoryViewController {
    func route(_ route: ScanHistoryViewModel.Route) {
        switch route {
        case .back:
            navigationController?.popViewController(animated: true)
        case .open(let analyseId):
            AnalyseScanResultAssembly().open(with: analyseId, from: self)
        }
    }
}
