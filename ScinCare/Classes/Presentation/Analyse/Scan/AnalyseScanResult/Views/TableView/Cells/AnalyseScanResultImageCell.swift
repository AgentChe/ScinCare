//
//  AnalyseScanResultImageCell.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 01.11.2024.
//

import UIKit
import Kingfisher

final class AnalyseScanResultImageCell: UITableViewCell {
    lazy var pictureView = makeImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
    }
}

// MARK: Public
extension AnalyseScanResultImageCell {
    func setup(element: URL) {
        pictureView.kf.setImage(with: element)
    }
}

// MARK: Private
private extension AnalyseScanResultImageCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension AnalyseScanResultImageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pictureView.widthAnchor.constraint(equalToConstant: 252.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 252.scale),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AnalyseScanResultImageCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16.scale
        view.layer.borderColor = Appearance.main900.cgColor
        view.layer.borderWidth = 4.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
