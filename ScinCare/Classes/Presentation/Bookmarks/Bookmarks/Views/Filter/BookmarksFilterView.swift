//
//  BookmarksFilterView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

import UIKit

final class BookmarksFilterView: UIScrollView {
    enum Filter {
        case procedures, diseases, glossaries
    }
    
    lazy var filter = Filter.procedures {
        didSet {
            update()
        }
    }
    
    lazy var proceduresButton = makeButton(text: "Bookmarks.Procedures".localized)
    lazy var diseasesButton = makeButton(text: "Bookmarks.Diseases".localized)
    lazy var glossariesButton = makeButton(text: "Bookmarks.Glossaries".localized)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension BookmarksFilterView {
    func update() {
        proceduresButton.marked = filter == .procedures
        diseasesButton.marked = filter == .diseases
        glossariesButton.marked = filter == .glossaries
    }
}

// MARK: Make constraints
private extension BookmarksFilterView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            proceduresButton.widthAnchor.constraint(equalToConstant: 98.scale),
            proceduresButton.heightAnchor.constraint(equalToConstant: 35.scale),
            proceduresButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            proceduresButton.topAnchor.constraint(equalTo: topAnchor),
            proceduresButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            diseasesButton.widthAnchor.constraint(equalToConstant: 73.scale),
            diseasesButton.heightAnchor.constraint(equalToConstant: 35.scale),
            diseasesButton.leadingAnchor.constraint(equalTo: proceduresButton.trailingAnchor, constant: 16.scale),
            diseasesButton.topAnchor.constraint(equalTo: topAnchor),
            diseasesButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            glossariesButton.widthAnchor.constraint(equalToConstant: 79.scale),
            glossariesButton.heightAnchor.constraint(equalToConstant: 35.scale),
            glossariesButton.leadingAnchor.constraint(equalTo: diseasesButton.trailingAnchor, constant: 16.scale),
            glossariesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            glossariesButton.topAnchor.constraint(equalTo: topAnchor),
            glossariesButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BookmarksFilterView {
    func makeButton(text: String) -> BookmarksFilterItemButton {
        let view = BookmarksFilterItemButton(text: text)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
