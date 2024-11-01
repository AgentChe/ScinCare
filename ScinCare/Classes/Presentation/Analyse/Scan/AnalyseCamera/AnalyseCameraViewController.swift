//
//  AnalyseCameraViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit
import RxSwift
import PhotosUI
import AVFoundation

final class AnalyseCameraViewController: UIViewController {
    enum Result {
        case close
        case image(UIImage)
    }
    
    private lazy var mainView = AnalyseCameraView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var cameraService: CameraService = {
        let cameraService = CameraService()
        cameraService.delegate = self
        return cameraService
    }()
    
    private let complete: (Result) -> Void
    
    private init(complete: @escaping (Result) -> Void) {
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
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, _ in
                base.setupCameraLayer()
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(result: .close)
            })
            .disposed(by: disposeBag)
        
        mainView.takePhotoButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.takePhoto()
            })
            .disposed(by: disposeBag)
        
        mainView.optionsView
            .wallpapersButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.fromWallapers()
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                mainView.optionsView.minusButton.rx.tap.map { -1 },
                mainView.optionsView.plusButton.rx.tap.map { 1 },
                mainView.optionsView.refreshButton.rx.tap.map { -20 } // Вернет зум на 1
            )
            .scan(1) { value, incr -> Int in
                let result = value + incr
                if result < 1 {
                    return 1
                } else if result > 10 {
                    return 10
                }
                return result
            }
            .bind(to: Binder(self) { base, zoom in
                base.cameraService.setZoom(scale: CGFloat(zoom))
                base.mainView.optionsView.sliderView.value = Float(zoom)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension AnalyseCameraViewController {
    static func make(complete: @escaping (Result) -> Void) -> AnalyseCameraViewController {
        let vc = AnalyseCameraViewController(complete: complete)
        vc.navigationItem.backButtonTitle = " "
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: PHPickerViewControllerDelegate
extension AnalyseCameraViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results
            .map (\.itemProvider)
            .filter { $0.canLoadObject(ofClass: UIImage.self) }
            .first
        guard let itemProvider else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            if let image = image as? UIImage {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(result: .image(image))
                }
            }
        }
    }
}

// MARK: CameraServiceDelegate
extension AnalyseCameraViewController: CameraServiceDelegate {
    func setPhoto(image: UIImage) {
        dismiss(result: .image(image))
    }
}

// MARK: Private
private extension AnalyseCameraViewController {
    func setupCameraLayer() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthStatus {
        case .authorized:
            let previewLayer = AVCaptureVideoPreviewLayer(session: cameraService.captureSession) as AVCaptureVideoPreviewLayer
            previewLayer.frame = mainView.cameraContainer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            mainView.cameraContainer.layer.insertSublayer(previewLayer, at: 0)
        default: break
        }
    }
        
    func dismiss(result: Result) {
        complete(result)
    }
    
    func takePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        cameraService.photoOutput.capturePhoto(with: photoSettings, delegate: cameraService)
    }
    
    func fromWallapers() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .automatic
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
}
