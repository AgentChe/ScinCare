//
//  SaveAnalyseCompleteView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 03.11.2024.
//

import UIKit

final class SaveAnalyseCompleteView: UIView {
    lazy var dimmedView = makeDimmedView()
    lazy var container = makeContainer()
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var reminderButton = makeReminderButton()
    lazy var laterButton = makeLaterButton()
    
    private lazy var containerYConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SaveAnalyseCompleteView {
    func animateShow() {
        containerYConstraint.isActive = false
        containerYConstraint = container.bottomAnchor.constraint(equalTo: bottomAnchor)
        containerYConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.dimmedView.alpha = 0.6
            self?.layoutIfNeeded()
        })
    }
    
    func animateDismiss(completion: @escaping (() -> Void)) {
        containerYConstraint.isActive = false
        containerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        containerYConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.dimmedView.alpha = 0
            self?.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}

// MARK: Make constraints
private extension SaveAnalyseCompleteView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        containerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            containerYConstraint,
            container.heightAnchor.constraint(equalToConstant: 449.scale),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100.scale),
            imageView.heightAnchor.constraint(equalToConstant: 100.scale),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            reminderButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            reminderButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            reminderButton.heightAnchor.constraint(equalToConstant: 54.scale),
            reminderButton.bottomAnchor.constraint(equalTo: laterButton.topAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            laterButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            laterButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            laterButton.heightAnchor.constraint(equalToConstant: 54.scale),
            laterButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -64.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SaveAnalyseCompleteView {
    func makeDimmedView() -> UIView {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main700
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "SaveAnalyseComplete.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 18.scale))
            .lineHeight(21.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "SaveAnalyseComplete.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.6))
            .font(Fonts.Roboto.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "SaveAnalyseComplete.Text".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeReminderButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Roboto.bold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("SaveAnalyseComplete.ReminderButton".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLaterButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("SaveAnalyseComplete.LaterButton".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main900
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
