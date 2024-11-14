//
//  CMRInputView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 11.11.2024.
//

import UIKit

final class CMRInputView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var headerView = makeHeaderView()
    lazy var nameField = makeNameField()
    lazy var repetitionView = makeRepetitionView()
    
    private weak var vc: UIViewController?
    
    init(vc: UIViewController?) {
        self.vc = vc
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CMRInputView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension CMRInputView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            nameField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            nameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 36.scale),
            nameField.heightAnchor.constraint(equalToConstant: 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            repetitionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            repetitionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            repetitionView.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16.scale),
            repetitionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            repetitionView.heightAnchor.constraint(equalToConstant: 44.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CMRInputView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(vertical: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHeaderView() -> CRHeaderView {
        let view = CRHeaderView(event: .medication)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeNameField() -> CRNameField {
        let view = CRNameField(event: .medication)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeRepetitionView() -> CRMRepetitionSelectView {
        let view = CRMRepetitionSelectView(vc: vc)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
}
