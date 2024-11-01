//
//  AnalyseScanResultRecommendationsCell.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 01.11.2024.
//

import UIKit

final class AnalyseScanResultRecommendationsCell: UITableViewCell {
    lazy var label = makeLabel()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.bold(size: 16.scale))
        .lineHeight(19.scale)
        .textAlignment(.left)
    private lazy var textAttrs = TextAttributes()
        .textColor(Appearance.mono200)
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
extension AnalyseScanResultRecommendationsCell {
    func setup(element: [AnalyseScanRecommendation]) {
        let result = NSMutableAttributedString()
        result.append("AnalyseScanResult.Recommendation".localized.attributed(with: titleAttrs))
        let text = element
            .map { $0.content }
            .joined(separator: "\n")
        result.append(text.attributed(with: textAttrs))
        label.attributedText = result
    }
}

// MARK: Private
private extension AnalyseScanResultRecommendationsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension AnalyseScanResultRecommendationsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AnalyseScanResultRecommendationsCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
