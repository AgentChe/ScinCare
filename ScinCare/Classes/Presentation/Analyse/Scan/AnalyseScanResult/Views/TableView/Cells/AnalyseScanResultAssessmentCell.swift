//
//  AnalyseScanResultAssessmentCell.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 01.11.2024.
//

import UIKit

final class AnalyseScanResultAssessmentCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var statusLabel = makeLabel()
    lazy var desctiptionLabel = makeLabel()
    
    private lazy var statusAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.regular(size: 16.scale))
        .lineHeight(19.scale)
        .textAlignment(.left)
    private lazy var descriptionAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.Roboto.regular(size: 16.scale))
        .lineHeight(19.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AnalyseScanResultAssessmentCell {
    func setup(element: AnalyseScanAssessment) {
        statusLabel.attributedText = element.status.attributed(with: statusAttrs)
        desctiptionLabel.attributedText = element.description.attributed(with: descriptionAttrs)
    }
}

// MARK: Private
private extension AnalyseScanResultAssessmentCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension AnalyseScanResultAssessmentCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.scale)
        ])
        
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            desctiptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            desctiptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            desctiptionLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8.scale),
            desctiptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AnalyseScanResultAssessmentCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "AnalyseScanResult.Assessment".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
