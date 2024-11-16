//
//  RepetitionEveryDayViewController.swift
//  ScinCare
//
//  Created by Vitaliy Zagorodnov on 15.11.2024.
//

import UIKit

class RepetitionEveryDayViewController: UIViewController {
    private lazy var mainView =  RepetitionEveryDayView()
    private var action: ((Date) -> Void)?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.confirmButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
    }
}

extension RepetitionEveryDayViewController {
    static func make(didSaveDate: @escaping (Date) -> Void) -> UIViewController {
        let vc = RepetitionEveryDayViewController()
        vc.action = didSaveDate
        return vc
    }
}

private extension RepetitionEveryDayViewController {
    @objc func saveAction() {
        action?(mainView.datePicker.date)
        dismiss(animated: true)
    }
}
