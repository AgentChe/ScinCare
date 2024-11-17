//
//  RepetitionsView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 12.11.2024.
//

import UIKit

final class RepetitionsView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var tableView = makeTableView()
    lazy var confirmButton = makeConfirmButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RepetitionsView {
    func initialize() {
        backgroundColor = Appearance.main700
    }
}

// MARK: Make constraints
private extension RepetitionsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            confirmButton.heightAnchor.constraint(equalToConstant: 54.scale),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RepetitionsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Repetitions.Title".localized.attributed(with: attrs)
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
    
    func makeTableView() -> RepetitionsTableView {
        let view = RepetitionsTableView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(vertical: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        view.showsVerticalScrollIndicator = false
        view.separatorColor = Appearance.main900
        view.separatorInset = UIEdgeInsets(horizontal: 16.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeConfirmButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Roboto.bold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Repetitions.Create.ConfirmButton".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
