//
//  CatalogsSearchField.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 22.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CatalogsSearchField: UIView {
    lazy var textField = makeTextField()
    lazy var iconView = makeIconView()
    
    private lazy var text = BehaviorRelay(value: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        textEditing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CatalogsSearchField {
    var changedText: Signal<String> {
        text.asSignal(onErrorSignalWith: .never())
    }
}

// MARK: UITextFieldDelegate
extension CatalogsSearchField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension CatalogsSearchField {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main900.cgColor
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
    
    @objc
    func textEditing() {
        text.accept(textField.text ?? "")
    }
}

// MARK: Make constraints
private extension CatalogsSearchField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CatalogsSearchField {
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.regular(size: 16.scale))
        
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Roboto.regular(size: 16.scale))
        
        let view = PaddingTextField()
        view.delegate = self
        view.backgroundColor = UIColor.clear
        view.textPadding = UIEdgeInsets(t: 12.5.scale, l: 38.scale, b: 12.5.scale, r: 8.scale)
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "Catalogs.Search".localized.attributed(with: placeholderAttrs)
        view.addTarget(self, action: #selector(textEditing), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Catalogs.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
