//
//  AnalyseScanResultTableView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 01.11.2024.
//

import UIKit

final class AnalyseScanResultTableView: UITableView {
    private lazy var elements = [AnalyseScanResultTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AnalyseScanResultTableView {
    func setup(elements: [AnalyseScanResultTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension AnalyseScanResultTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .image(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: AnalyseScanResultImageCell.self)) as! AnalyseScanResultImageCell
            cell.setup(element: element)
            return cell
        case .name(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: AnalyseScanResultNameCell.self)) as! AnalyseScanResultNameCell
            cell.setup(element: element)
            return cell
        case .assessment(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: AnalyseScanResultAssessmentCell.self)) as! AnalyseScanResultAssessmentCell
            cell.setup(element: element)
            return cell
        case .conclusion(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: AnalyseScanResultConclusionCell.self)) as! AnalyseScanResultConclusionCell
            cell.setup(element: element)
            return cell
        case .recommendations(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: AnalyseScanResultRecommendationsCell.self)) as! AnalyseScanResultRecommendationsCell
            cell.setup(element: element)
            return cell
        case .description(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: AnalyseScanResultDescriptionCell.self)) as! AnalyseScanResultDescriptionCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension AnalyseScanResultTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension AnalyseScanResultTableView {
    func initialize() {
        register(AnalyseScanResultImageCell.self, forCellReuseIdentifier: String(describing: AnalyseScanResultImageCell.self))
        register(AnalyseScanResultNameCell.self, forCellReuseIdentifier: String(describing: AnalyseScanResultNameCell.self))
        register(AnalyseScanResultAssessmentCell.self, forCellReuseIdentifier: String(describing: AnalyseScanResultAssessmentCell.self))
        register(AnalyseScanResultConclusionCell.self, forCellReuseIdentifier: String(describing: AnalyseScanResultConclusionCell.self))
        register(AnalyseScanResultRecommendationsCell.self, forCellReuseIdentifier: String(describing: AnalyseScanResultRecommendationsCell.self))
        register(AnalyseScanResultDescriptionCell.self, forCellReuseIdentifier: String(describing: AnalyseScanResultDescriptionCell.self))
        
        dataSource = self
        delegate = self 
    }
}
