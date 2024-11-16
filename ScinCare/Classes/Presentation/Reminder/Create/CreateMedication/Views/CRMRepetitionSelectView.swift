//
//  CRMRepetitionSelectView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 14.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CRMRepetitionSelectView: UIView {
    lazy var label = makeLabel()
    lazy var arrowView = makeArrowView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.regular(size: 16.scale))
        .lineHeight(19.scale)
        .textAlignment(.left)
    
    private lazy var disposeBag = DisposeBag()
    
    private weak var vc: UIViewController?
    
    private var selected: RepetitionsTableElement.Repetition?
    private let selectedRepetition = BehaviorRelay<Repetition?>(value: nil)
    
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

extension CRMRepetitionSelectView {
    var repetition: Observable<Repetition?> {
        selectedRepetition.asObservable()
    }
    
    var repetitionBinder: Binder<Repetition> {
        Binder(self) { base, repetition in
            let element = RepetitionsTableElement(repetition: .init(repetition), marked: true)
            let attrs = TextAttributes()
                .font(Fonts.Roboto.regular(size: 16.scale))
                .textColor(Appearance.mono200)
                .textAlignment(.left)
            base.selected = element.repetition
            base.label.attributedText = element.localizedTitle.attributed(with: attrs)
        }
    }
}

// MARK: Private
private extension CRMRepetitionSelectView {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 4.scale
        layer.masksToBounds = true
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main900.cgColor
        
        let tapGesture = UITapGestureRecognizer()
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        
        let assembly = RepetitionsAssembly { [weak self] value in
            self?.selectedRepetition.accept(value)
        }
        
        tapGesture.rx.event
            .bind(to: Binder(self) { base, event in
                guard let vc = base.vc else { return }
                assembly.select(from: vc, event: .medication, initial: base.selected)
            })
            .disposed(by: disposeBag)
    }
}

extension RepetitionsTableElement.Repetition {
    init(_ value: Repetition) {
        switch value {
        case .everyDay:
            self = .everyDay
        case .everyMinutes:
            self = .everyMinutes
        case .everyHours:
            self = .everyHours
        case .everyDays:
            self = .everyDays
        case .everyMonth:
            self = .everyMonth
        case .everyYear:
            self = .everyYear
        case .onSpecificDate:
            self = .onSpecificDate
        }
    }
}

// MARK: Make constraints
private extension CRMRepetitionSelectView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 24.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 24.scale),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CRMRepetitionSelectView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CreateReminder.ArrowRigth")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
