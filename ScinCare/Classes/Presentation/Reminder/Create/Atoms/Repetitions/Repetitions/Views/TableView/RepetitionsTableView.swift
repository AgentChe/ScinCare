//
//  RepetitionsTableView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 12.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class RepetitionsTableView: UITableView {
    private lazy var elements = [RepetitionsTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<RepetitionsTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RepetitionsTableView {
    func setup(elements: [RepetitionsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<RepetitionsTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension RepetitionsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: RepetitionsTableCell.self), for: indexPath) as! RepetitionsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension RepetitionsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        elements.forEach { $0.marked = false }
        elements[indexPath.row].marked = true
        
        reloadData()
        
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension RepetitionsTableView {
    func initialize() {
        register(RepetitionsTableCell.self, forCellReuseIdentifier: String(describing: RepetitionsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
