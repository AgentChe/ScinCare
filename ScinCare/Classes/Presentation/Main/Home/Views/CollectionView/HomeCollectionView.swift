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
        case .explore:
            return CGSize(width: bounds.width, height: 411.scale)
        }
    }
}

// MARK: Private
private extension HomeCollectionView {
    func initialize() {
        register(HomeExploreCell.self, forCellWithReuseIdentifier: String(describing: HomeExploreCell.self))
        
        dataSource = self
        delegate = self
    }
}
