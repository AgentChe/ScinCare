//
//  AnalyseImageResizeViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit
import RxSwift
import RxCocoa
import Mantis

final class AnalyseImageResizeViewController: UIViewController {
    enum Result {
        case image(UIImage)
        case retake
        case back
    }
    
    private lazy var mainView = AnalyseImageResizeView()
    
    private lazy var viewModel = AnalyseImageResizeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private weak var cropVC: CropViewController?
    
    private lazy var didCroppedImageTrigger = PublishRelay<UIImage>()
    
    private let originalImage: UIImage
    private let complete: (Result) -> Void
    
    private init(image: UIImage, complete: @escaping (Result) -> Void) {
        self.originalImage = image
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
            .bind(to: Binder(self) { base, void in
                base.makeCropView(image: base.originalImage)
            })
            .disposed(by: disposeBag)
        
        mainView.backButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.complete(.back)
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: AnalyseImageResizeViewModel.Input(
            didTapBack: mainView.backButton.rx.tap.asSignal(),
            didAcceptPhoto: mainView.optionsView.didAcceptPhoto,
            didRetakePhoto: mainView.optionsView.didRetakePhoto,
            didContinue: mainView.optionsView.didContinue,
            pushCroppedImage: didCroppedImageTrigger.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension AnalyseImageResizeViewController {
    static func make(image: UIImage, complete: @escaping (Result) -> Void) -> AnalyseImageResizeViewController {
        AnalyseImageResizeViewController(image: image, complete: complete)
    }
}

// MARK: CropViewControllerDelegate
extension AnalyseImageResizeViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        didCroppedImageTrigger.accept(cropped)
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        didCroppedImageTrigger.accept(original)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {}
}

// MARK: Private
private extension AnalyseImageResizeViewController {
    func makeCropView(image: UIImage) {
        var cropViewConfig = CropViewConfig()
        cropViewConfig.showAttachedRotationControlView = false
        
        var config = Config()
        config.showAttachedCropToolbar = false
        config.cropViewConfig = cropViewConfig
        
        let cropVC = Mantis.cropViewController(image: image, config: config)
        cropVC.delegate = self
        
        self.cropVC = cropVC
        
        addChild(cropVC)
        cropVC.view.frame = mainView.imageContainer.bounds
        mainView.imageContainer.addSubview(cropVC.view)
        cropVC.willMove(toParent: self)
    }
    
    func route(_ route: AnalyseImageResizeViewModel.Route) {
        switch route {
        case .back:
            complete(.back)
        case .retake:
            complete(.retake)
        case .finish(let image):
            complete(.image(image))
        }
    }
    
    func action(_ action: AnalyseImageResizeViewModel.Action) {
        switch action {
        case .crop:
            cropVC?.crop()
        case .changeOptionsState(let state):
            mainView.optionsView.setup(state: state)
        }
    }
}
