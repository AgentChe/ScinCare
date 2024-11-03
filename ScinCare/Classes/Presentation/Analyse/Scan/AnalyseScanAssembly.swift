//
//  AnalyseScanAssembly.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit
import AVFoundation

final class AnalyseScanAssembly {
    func scan(from: UIViewController) {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthStatus {
        case .authorized:
            startScanFlow(from: from)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] authorized in
                authorized ? self?.startScanFlow(from: from) : self?.notPermission(from: from)
            }
        default:
            notPermission(from: from)
        }
    }
}

// MARK: Private
private extension AnalyseScanAssembly {
    func startScanFlow(from: UIViewController) {
        let nc = NavigationController()
        nc.modalPresentationStyle = .fullScreen
        
        let cameraVC = AnalyseCameraViewController.make { [weak nc] result in
            switch result {
            case .close:
                nc?.dismiss(animated: true)
            case .image(let image):
                let resizeVC = AnalyseImageResizeViewController.make(image: image) { [weak self, weak nc] result in
                    guard let self else { return }
                    
                    switch result {
                    case .image(let croppedImage):
                        let resultNC = self.startResultFlow(croppedImage: croppedImage) { [weak from] in
                            from?.dismiss(animated: true)
                        }
                        nc?.present(resultNC, animated: true)
                    case .retake, .back:
                        nc?.popViewController(animated: true)
                    }
                }
                nc?.pushViewController(resizeVC, animated: true)
            }
        }
        nc.setViewControllers([cameraVC], animated: false)
        
        from.present(nc, animated: true)
    }
    
    func startResultFlow(croppedImage: UIImage, complete: @escaping () -> Void) -> UINavigationController {
        let nc = NavigationController()
        nc.modalPresentationStyle = .fullScreen
        
        let scanResultVC = AnalyseScanResultViewController.make(image: croppedImage) { [weak nc] result in
            switch result {
            case .close:
                complete()
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
                                let resultVC = SaveAnalyseCompleteViewController.make { result in
                                    switch result {
                                    case .setNotification:
                                        break // TODO
                                    case .later:
                                        complete()
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
                break // TODO
            }
        }
        nc.setViewControllers([scanResultVC], animated: false)
        
        return nc
    }
    
    func notPermission(from: UIViewController) {
        let alert = UIAlertController(
            title: "AnalyseCamera.NotPermissions.Title".localized,
            message: "AnalyseCamera.NotPermissions.Text".localized,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK".localized, style: .cancel)
        alert.addAction(okAction)
        
        from.present(alert, animated: true)
    }
}
