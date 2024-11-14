//
//  RepetitionsAssembly.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 14.11.2024.
//

import UIKit

final class RepetitionsAssembly {
    func select(from: UIViewController, event: Reminder.Event, initial: RepetitionsTableElement.Repetition? = nil) {
        let nc = NavigationController()
        
        let repetitionsInputBundle = RepetitionsViewController.Bundle(
            event: event,
            initial: initial
        )
        
        let repetitionsVC = RepetitionsViewController.make(inputBundle: repetitionsInputBundle) { [weak nc] repetitionsResult in
            switch repetitionsResult {
            case .close:
                nc?.dismiss(animated: true)
            }
        }
        
        nc.setViewControllers([repetitionsVC], animated: false)
        
        from.present(nc, animated: true)
    }
}
