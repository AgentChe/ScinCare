//
//  AnalyseScanResultAssembly.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 03.11.2024.
//

import UIKit

final class AnalyseScanResultAssembly {
    func open(with analyseId: String, from: UIViewController) {
        let nc = NavigationController()
        nc.modalPresentationStyle = .fullScreen
        
        let scanResultVC = AnalyseScanResultViewController.make(analyseId: analyseId) { [weak nc] result in
            switch result {
            case .close:
                nc?.dismiss(animated: true)
            case .save(let analyseId):
                let selectSkinAreaVC = SaveAnalyseSelectSkinAreaViewController.make(analyseId: analyseId) { [weak nc] result in
                    switch result {
                    case .back:
                        nc?.popViewController(animated: true)
                    case .output(let output):
                        let input = SaveAnalyseSetTitleViewController.Input(
                            analyseId: output.analyseId,
                            side: output.side,
                            area: output.area
                        )
                        
                        let setTitleVC = SaveAnalyseSetTitleViewController.make(input: input) { [weak nc] result in
                            switch result {
                            case .back:
                                nc?.popViewController(animated: true)
                            case .complete:
                                let resultVC = SaveAnalyseCompleteViewController.make { vc, result in
                                    switch result {
                                    case .setNotification:
                                        CreateReminderAssembly().create(from: vc)
                                    case .later:
                                        nc?.dismiss(animated: true)
                                    }
                                }
                                nc?.present(resultVC, animated: false)
                            }
                        }
                        nc?.pushViewController(setTitleVC, animated: true)
                    }
                }
                nc?.pushViewController(selectSkinAreaVC, animated: true)
            case .setNotifications(let analyseId):
                if let nc {
                    CreateReminderAssembly().create(from: nc)
                }
            }
        }
        
        nc.setViewControllers([scanResultVC], animated: false)
        
        from.present(nc, animated: true)
    }
}
