//
//  HomeCollectionView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 21.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeCollectionView: UICollectionView {
    private lazy var elements = [HomeCollectionElement]()
    
    private lazy var didOpenScannerTrigger = PublishRelay<Void>()
    private lazy var didOpenHistoryTrigger = PublishRelay<Void>()
    private lazy var didAddReminderTrigger = PublishRelay<Void>()
    private lazy var didTapExploreTrigger = PublishRelay<HomeExploreItemButton.Item>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeCollectionView {
    func setup(elements: [HomeCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didOpenScanner: Signal<Void> {
        didOpenScannerTrigger.asSignal()
    }
    
    var didOpenHistory: Signal<Void> {
        didOpenHistoryTrigger.asSignal()
    }
    
    var didAddReminder: Signal<Void> {
        didAddReminderTrigger.asSignal()
    }
    
    var didTapExplore: Signal<HomeExploreItemButton.Item> {
        didTapExploreTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension HomeCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .openScanner:
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: HomeOpenScannerCell.self), for: indexPath) as! HomeOpenScannerCell
            cell.didOpenScanner = { [weak self] in
                self?.didOpenScannerTrigger.accept(())
            }
            return cell
        case .openHistory:
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: HomeOpenHistoryCell.self), for: indexPath) as! HomeOpenHistoryCell
            cell.didOpenHistory = { [weak self] in
                self?.didOpenHistoryTrigger.accept(Void())
            }
            return cell
        case .addReminder:
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: HomeAddReminderCell.self), for: indexPath) as! HomeAddReminderCell
            cell.didAddReminder = { [weak self] in
                self?.didAddReminderTrigger.accept(Void())
            }
            return cell
        case .explore:
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: HomeExploreCell.self), for: indexPath) as! HomeExploreCell
            cell.didTap = { [weak self] item in
                self?.didTapExploreTrigger.accept(item)
            }
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch elements[indexPath.row] {
        case .openScanner, .openHistory, .addReminder:
            return CGSize(width: bounds.width, height: 194.scale)
        case .explore:
            return CGSize(width: bounds.width, height: 411.scale)
        }
    }
}

// MARK: Private
private extension HomeCollectionView {
    func initialize() {
        register(HomeOpenScannerCell.self, forCellWithReuseIdentifier: String(describing: HomeOpenScannerCell.self))
        register(HomeOpenHistoryCell.self, forCellWithReuseIdentifier: String(describing: HomeOpenHistoryCell.self))
        register(HomeAddReminderCell.self, forCellWithReuseIdentifier: String(describing: HomeAddReminderCell.self))
        register(HomeExploreCell.self, forCellWithReuseIdentifier: String(describing: HomeExploreCell.self))
        
        dataSource = self
        delegate = self
    }
}
