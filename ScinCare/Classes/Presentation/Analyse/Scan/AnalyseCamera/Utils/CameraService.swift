//
//  CameraService.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit
import AVFoundation

protocol CameraServiceDelegate: AnyObject {
    func setPhoto(image: UIImage)
}

final class CameraService: NSObject {
    weak var delegate: CameraServiceDelegate?

    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    
    private var captureDevice: AVCaptureDevice?
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?

    private var backInput: AVCaptureInput!
    private var frontInput: AVCaptureInput!
    private let cameraQueue = DispatchQueue(label: "com.capturingQueue")

    private var startZoom: CGFloat = 1.0
    private let zoomLimit: CGFloat = 10.0

    private var backCameraOn = true

    override init() {
        super.init()
        
        setupAndStartCaptureSession()
    }

    func setZoom(scale: CGFloat) {
        updateZoom(scale: minMaxZoom(scale))
    }

    func switchCameraInput() {
        captureSession.beginConfiguration()
        if backCameraOn {
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            captureDevice = frontCamera
            backCameraOn = false
        } else {
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            captureDevice = backCamera
            backCameraOn = true
            updateZoom(scale: startZoom)
        }

        photoOutput.connections.first?.videoOrientation = .portrait
        photoOutput.connections.first?.isVideoMirrored = !backCameraOn
        captureSession.commitConfiguration()
    }
}

// MARK: AVCapturePhotoCaptureDelegate
extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Fail to capture photo: \(String(describing: error))")
            return
        }
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        guard let image = UIImage(data: imageData) else {
            return
        }

        DispatchQueue.main.async {
            self.delegate?.setPhoto(image: image)
        }
    }
}

// MARK: Private
private extension CameraService {
    func currentDevice() -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:
                                                                    [.builtInTripleCamera,.builtInDualWideCamera, .builtInDualCamera, .builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .back)
        guard let device = discoverySession.devices.first
        else {
            return nil
        }

        if device.deviceType == .builtInDualCamera || device.deviceType == .builtInWideAngleCamera {
            startZoom = 1.0
        }
        return device
    }

    func setupAndStartCaptureSession() {
        cameraQueue.async { [weak self] in
            self?.captureSession.beginConfiguration()

            if let canSetSessionPreset = self?.captureSession.canSetSessionPreset(.photo), canSetSessionPreset {
                self?.captureSession.sessionPreset = .photo
            }
            self?.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true

            self?.setupInputs()
            self?.setupOutput()

            self?.captureSession.commitConfiguration()
            self?.captureSession.startRunning()
        }
    }
    
    func setupInputs() {
        backCamera = currentDevice()
        frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)

        guard let backCamera = backCamera,
              let frontCamera = frontCamera
        else {
            return
        }

        do {
            backInput = try AVCaptureDeviceInput(device: backCamera)
            guard captureSession.canAddInput(backInput) else {
                return
            }

            frontInput = try AVCaptureDeviceInput(device: frontCamera)
            guard captureSession.canAddInput(frontInput) else {
                return
            }
        } catch {
            fatalError("could not connect camera")
        }

        captureDevice = backCamera

        captureSession.addInput(backInput)

        if backCamera.deviceType == .builtInDualWideCamera || backCamera.deviceType == .builtInTripleCamera {
            updateZoom(scale: startZoom)
        }
    }

    func setupOutput() {
        guard captureSession.canAddOutput(photoOutput) else {
            return
        }

        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.maxPhotoQualityPrioritization = .balanced

        captureSession.addOutput(photoOutput)
    }

    func minMaxZoom(_ factor: CGFloat) -> CGFloat {
        guard let captureDevice else {
            return min(max(factor, 1.0), zoomLimit)
        }

        let minZoom = max(1.0, captureDevice.minAvailableVideoZoomFactor)
        let maxZoom = min(zoomLimit, captureDevice.maxAvailableVideoZoomFactor)
        return min(max(factor, minZoom), maxZoom)
    }

    func updateZoom(scale: CGFloat) {
        guard let captureDevice else {
            return
        }

        do {
            try captureDevice.lockForConfiguration()
            defer { captureDevice.unlockForConfiguration() }
            captureDevice.videoZoomFactor = scale
        } catch {
            print(error.localizedDescription)
        }
    }
}
