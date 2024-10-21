//
//  OnboardingSlideView.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 08.09.2024.
//

import UIKit

protocol OnboardingSlideViewDelete: AnyObject {
    func slideViewDidNext(from slide: OnboardingView.Slide)
    func slideViewDidBack(from slide: OnboardingView.Slide)
}

class OnboardingSlideView: UIView {
    let slide: OnboardingView.Slide
    
    weak var delegate: OnboardingSlideViewDelete?
    
    init(slide: OnboardingView.Slide) {
        self.slide = slide
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToThis() {}
    
    @objc
    func onNext() {
        delegate?.slideViewDidNext(from: slide)
    }
    
    @objc
    func onBack() {
        delegate?.slideViewDidBack(from: slide)
    }
}
