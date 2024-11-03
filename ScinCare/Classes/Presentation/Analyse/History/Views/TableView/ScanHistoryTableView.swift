//
//  ScanHistoryTableView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 03.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ScanHistoryTableView: UITableView {
    private lazy var elements = [AnalyseScanTemplate]()
    
    private lazy var didSelectTrigger = PublishRelay<AnalyseScanTemplate>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ScanHistoryTableView {
    func setup(elements: [AnalyseScanTemplate]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<AnalyseScanTemplate> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension ScanHistoryTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: ScanHistoryTableCell.self), for: indexPath) as! ScanHistoryTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension ScanHistoryTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension ScanHistoryTableView {
    func initialize() {
        register(ScanHistoryTableCell.self, forCellReuseIdentifier: String(describing: ScanHistoryTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
