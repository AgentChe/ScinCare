//
//  CMRView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 11.11.2024.
//

import UIKit

final class CMRView: UIView {
    lazy var backButton = makeBackButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var inputDataView = makeInputDataView()
    lazy var confirmButton = makeConfirmButton()
    lazy var deleteButton = makeRemoveButton()
    
    private weak var vc: UIViewController?
    private let mode: CMRViewController.Mode
    
    init(vc: UIViewController, mode: CMRViewController.Mode) {
        self.vc = vc
        self.mode = mode
        
        super.init(frame: .zero)
        
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CMRView {
    func initialize() {
        backgroundColor = Appearance.main700
        if case .edit = mode {
            addSubview(deleteButton)
        }
    }
}

// MARK: Make constraints
private extension CMRView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24.scale),
            backButton.heightAnchor.constraint(equalToConstant: 24.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            inputDataView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            inputDataView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            inputDataView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 2.scale),
            inputDataView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -2.scale)
        ])
        
        switch mode {
        case .create:
            NSLayoutConstraint.activate([
                confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
                confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
                confirmButton.heightAnchor.constraint(equalToConstant: 54.scale),
                confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale)
            ])
        case .edit:
            NSLayoutConstraint.activate([
                confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
                confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
                confirmButton.heightAnchor.constraint(equalToConstant: 54.scale),
                confirmButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -12.scale)
            ])
            
            NSLayoutConstraint.activate([
                deleteButton.leadingAnchor.constraint(equalTo: confirmButton.leadingAnchor),
                deleteButton.trailingAnchor.constraint(equalTo: confirmButton.trailingAnchor),
                deleteButton.heightAnchor.constraint(equalToConstant: 54.scale),
                deleteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale)
            ])
        }
    }
}

// MARK: Lazy initialization
private extension CMRView {
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Back.Black"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = mode.title.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Close.Black"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInputDataView() -> CMRInputView {
        let view = CMRInputView(vc: vc, event: mode.event)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeConfirmButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Roboto.bold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle(mode.confirmTitle.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRemoveButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Roboto.bold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Repetitions.RemoveButton".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.system100
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

private extension CMRViewController.Mode {
    var title: String {
        switch self {
        case .edit:
            "CreteMedication.Edit.Title".localized
        case .create:
            "CreteMedication.Create.Title".localized
        }
    }
    
    var confirmTitle: String {
        switch self {
        case .edit:
            "Repetitions.Edit.ConfirmButton".localized
        case .create:
            "Repetitions.Create.ConfirmButton".localized
        }
    }
}
