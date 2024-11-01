//
//  AnalyseScanResultConclusionCell.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 01.11.2024.
//

import UIKit

final class AnalyseScanResultConclusionCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var valueLabel = makeLabel()
    lazy var progressView = makeProgressView()
    
    private lazy var valueAttrs = TextAttributes()
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
extension AnalyseScanResultConclusionCell {
    func setup(element: AnalyseScanConclusion) {
        progressView.setup(progress: element.percent)
        valueLabel.attributedText = element.value.attributed(with: valueAttrs)
    }
}

// MARK: Private
private extension AnalyseScanResultConclusionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension AnalyseScanResultConclusionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 85.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.scale),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8.scale),
            valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -54.scale),
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.scale),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 38.scale),
            progressView.heightAnchor.constraint(equalToConstant: 38.scale),
            progressView.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AnalyseScanResultConclusionCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Roboto.bold(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "AnalyseScanResult.Conclusion".localized.attributed(with: attrs)
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
    
    func makeProgressView() -> ASRCircleProgressView {
        let view = ASRCircleProgressView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
