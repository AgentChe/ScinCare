//
//  CreateReminderAssembly.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 11.11.2024.
//

import UIKit

final class CreateReminderAssembly {
    func create(from: UIViewController) {
        let nc = NavigationController()
        
        let chooseReminderEventVC = CREViewController.make { [weak nc] creResult in
            switch creResult {
            case .close:
                nc?.dismiss(animated: true)
            case .medication:
                let cmrVC = CMRViewController.make(mode: .create(.medication)) { [weak nc] cmrResult in
                    switch cmrResult {
                    case .back:
                        nc?.popViewController(animated: true)
                    case .close:
                        nc?.dismiss(animated: true)
                    }
                }
                nc?.pushViewController(cmrVC, animated: true)
            case .skinRescan:
                let cmrVC = CMRViewController.make(mode: .create(.skinRescan)) { [weak nc] cmrResult in
                    switch cmrResult {
                    case .back:
                        nc?.popViewController(animated: true)
                    case .close:
                        nc?.dismiss(animated: true)
                    }
                }
                nc?.pushViewController(cmrVC, animated: true)
            }
        }
        
        nc.setViewControllers([chooseReminderEventVC], animated: false)
        
        from.present(nc, animated: true)
    }
    
    func open(from: UIViewController, reminder: Reminder) {
        
        
        let cmrVC = CMRViewController.make(mode: .edit(reminder)) { [weak from] cmrResult in
            switch cmrResult {
            case .back:
                from?.dismiss(animated: true)
            case .close:
                from?.dismiss(animated: true)
            }
        }
        let nc = NavigationController(rootViewController: cmrVC)
        
        from.present(nc, animated: true)
    }
}
