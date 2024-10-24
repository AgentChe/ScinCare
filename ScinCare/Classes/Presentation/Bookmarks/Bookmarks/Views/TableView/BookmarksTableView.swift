//
//  BookmarksTableView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class BookmarksTableView: UITableView {
    lazy var elements = [BookmarksTableElement]()
    
    private lazy var didTapCatalogTrigger = PublishRelay<Catalog>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension BookmarksTableView {
    func setup(elements: [BookmarksTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapCatalog: Signal<Catalog> {
        didTapCatalogTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension BookmarksTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: BookmarksTableCell.self)) as! BookmarksTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension BookmarksTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTapCatalogTrigger.accept(elements[indexPath.row].catalog)
    }
}

// MARK: Private
private extension BookmarksTableView {
    func initialize() {
        register(BookmarksTableCell.self, forCellReuseIdentifier: String(describing: BookmarksTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
