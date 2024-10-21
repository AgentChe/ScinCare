//
//  OnboardingView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingView: UIView {
    enum Slide: Int {
        case welcome1, welcome2, welcome3
    }
    
    private lazy var slidesViews: [OnboardingSlideView] = [
        OnboardingSlideView(slide: .welcome1),
        OnboardingSlideView(slide: .welcome1)
    ]
    
    private lazy var currentSlide = Slide.welcome1
    
    private let didFinish: (() -> Void)
    
    init(didFinish: @escaping (() -> Void)) {
        self.didFinish = didFinish
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        slidesViews.enumerated().forEach { [weak self] index, slideView in
            guard let self else { return }
            
            slideView.frame.size = bounds.size
        }
    }
}

// MARK: OnboardingSlideViewDelete
extension OnboardingView: OnboardingSlideViewDelete {
    func slideViewDidNext(from slide: Slide) {
        let nextRawValue = slide.rawValue + 1
        
        guard let nextSlide = Slide(rawValue: nextRawValue) else {
            didFinish()
            
            return
        }
        
        scroll(to: nextSlide)
    }
    
    func slideViewDidBack(from slide: Slide) {
        let previousRawValue = slide.rawValue - 1
        
        guard let previousSlide = Slide(rawValue: previousRawValue) else { return }
        
        scroll(to: previousSlide)
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        backgroundColor = Appearance.main100
        
        slidesViews.forEach { [weak self] slideView in
            guard let self else { return }
            
            slideView.clipsToBounds = true
            slideView.delegate = self
            
            if slideView.slide == currentSlide {
                slideView.frame.origin = CGPoint.zero
                addSubview(slideView)
                
                slideView.moveToThis()
            }
        }
    }
    
    func scroll(to slide: Slide) {
        let currentIndex = currentSlide.rawValue
        let scrollToIndex = slide.rawValue
        
        let direction = scrollToIndex > currentIndex ? 1 : -1
        
        let indices = slidesViews.indices
        
        guard indices.contains(currentIndex), indices.contains(scrollToIndex) else { return }

        let currentView = slidesViews[currentIndex]
        let scrollToView = slidesViews[scrollToIndex]
        
        scrollToView.frame.origin = CGPoint(x: 0, y: bounds.size.height * CGFloat(direction))
        addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            currentView.frame.origin = CGPoint(x: 0, y: bounds.size.height * -CGFloat(direction))
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { [weak self] result in
            guard let self = self else { return }
            
            currentView.removeFromSuperview()
            
            scrollToView.moveToThis()
            
            self.currentSlide = slide
        })
    }
}
