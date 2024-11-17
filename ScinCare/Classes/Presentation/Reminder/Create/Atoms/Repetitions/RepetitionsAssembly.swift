//
//  RepetitionsAssembly.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 14.11.2024.
//

import UIKit

final class RepetitionsAssembly {
    private let selectedRepetition: ((Repetition) -> Void)
    
    init(selectedRepetition: @escaping (Repetition) -> Void) {
        self.selectedRepetition = selectedRepetition
    }
    
    func select(from: UIViewController, event: Reminder.Event, initial: RepetitionsTableElement.Repetition? = nil) {
        let nc = NavigationController()
        
        let repetitionsInputBundle = RepetitionsViewController.Bundle(
            event: event,
            initial: initial
        )
        
        let repetitionsVC = RepetitionsViewController.make(inputBundle: repetitionsInputBundle) { [weak nc, weak self] repetitionsResult in
            switch repetitionsResult {
            case .close:
                nc?.dismiss(animated: true)
            case let .repetition(repetition):
                self?.selectedRepetition(repetition)
                nc?.dismiss(animated: true)
            }
        }
        
        nc.setViewControllers([repetitionsVC], animated: false)
        
        from.present(nc, animated: true)
    }
}
