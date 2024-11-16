//
//  RepetitionSpecificDayViewController.swift
//  ScinCare
//
//  Created by Vitaliy Zagorodnov on 15.11.2024.
//

import UIKit

class RepetitionSpecificDayViewController: UIViewController {

    private lazy var mainView =  RepetitionSpecificDayView()
    private var action: ((Date) -> Void)?
    private var minDate: Date?
    private var maxDate: Date?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.setup(minDate: minDate, maxDate: maxDate)
        mainView.confirmButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
    }
}

extension RepetitionSpecificDayViewController {
    static func make(min: Date? = nil, max: Date? = nil, didSaveDate: @escaping (Date) -> Void) -> UIViewController {
        let vc = RepetitionSpecificDayViewController()
        vc.action = didSaveDate
        vc.minDate = min
        vc.maxDate = max
        return vc
    }
}

private extension RepetitionSpecificDayViewController {
    @objc func saveAction() {
        action?(mainView.datePicker.date)
    }
}
