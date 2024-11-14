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
                let cmrVC = CMRViewController.make { [weak nc] cmrResult in
                    switch cmrResult {
                    case .back:
                        nc?.popViewController(animated: true)
                    case .close:
                        nc?.dismiss(animated: true)
                    }
                }
                nc?.pushViewController(cmrVC, animated: true)
            case .skinRescan:
                break // TODO
            }
        }
        
        nc.setViewControllers([chooseReminderEventVC], animated: false)
        
        from.present(nc, animated: true)
    }
}
