//
//  AnalyseScanResultView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 01.11.2024.
//

import UIKit

final class AnalyseScanResultView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var tableView = makeTableView()
    lazy var disclaimerLabel = makeDisclaimerLabel()
    lazy var saveButton = makeSaveButton()
    lazy var preloader = makePreloader()
    
    private lazy var disclaimerBottomConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AnalyseScanResultView {
    func saveButton(hidden: Bool) {
        saveButton.isHidden = hidden
        
        disclaimerBottomConstraint.isActive = false
        if hidden {
            disclaimerBottomConstraint = disclaimerLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8.scale)
        } else {
            disclaimerBottomConstraint = disclaimerLabel.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -8.scale)
        }
        disclaimerBottomConstraint.isActive = true
        
        layoutIfNeeded()
    }
}

// MARK: Private
private extension AnalyseScanResultView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension AnalyseScanResultView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: disclaimerLabel.topAnchor, constant: -2.scale)
        ])
        
        disclaimerBottomConstraint = disclaimerLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8.scale)
        NSLayoutConstraint.activate([
            disclaimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            disclaimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            disclaimerBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 54.scale),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 24.scale),
            preloader.heightAnchor.constraint(equalToConstant: 24.scale),
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AnalyseScanResultView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 22.scale))
            .lineHeight(30.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "AnalyseScanResult.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "AnalyseScanResult.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> AnalyseScanResultTableView {
        let view = AnalyseScanResultTableView()
        view.contentInset = UIEdgeInsets(vertical: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        view.separatorStyle = .none
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDisclaimerLabel() -> UILabel {
        let bAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Roboto.bold(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        let rAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Roboto.regular(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        let underlineAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Roboto.regular(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
            .underlineColor(Appearance.mono200.withAlphaComponent(0.23))
            .underlineStyle(.single)
        
        let result = NSMutableAttributedString()
        result.append("Onboarding.BottomInfo1".localized.attributed(with: rAttrs))
        result.append("Onboarding.BottomInfo2".localized.attributed(with: bAttrs))
        result.append("Onboarding.BottomInfo3".localized.attributed(with: rAttrs))
        result.append("Onboarding.BottomInfo4".localized.attributed(with: underlineAttrs))
        
        let view = UILabel()
        view.attributedText = result
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSaveButton() -> UIButton {
        let whiteButtonAttrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Roboto.bold(size: 16.scale))
        
        let view = UIButton()
        view.isHidden = true
        view.setAttributedTitle("AnalyseScanResult.SaveButton".localized.attributed(with: whiteButtonAttrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true 
        view.style = .large
        view.color = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
