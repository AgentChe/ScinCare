//
//  SASTInputField.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 03.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SASTInputField: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var textField = makeTextField()
    
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
extension SASTInputField {
    var text: Signal<String> {
        textField.rx.text
            .map { $0 ?? "" }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension SASTInputField {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension SASTInputField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SASTInputField {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "SaveAnalyseSetTitle.AddTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.3))
            .font(Fonts.Roboto.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.left)
        let textAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.left)
        
        let view = PaddingTextField()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 4.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.main900.cgColor
        view.attributedPlaceholder = "SaveAnalyseSetTitle.TitlePlaceholder".localized.attributed(with: placeholderAttrs)
        view.defaultTextAttributes = textAttrs.dictionary
        view.textPadding = UIEdgeInsets(vertical: 13.scale, horizontal: 16.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
