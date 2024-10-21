//
//  OnboardingView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingView: UIView {
    enum Slide: Int {
        case disclaimer, scanScin, exploreSkinInsights, stayOnTrack, chat
    }
    
    lazy var container = makeContainer()
    lazy var stepsView = makeStepsView()
    lazy var slidesViews: [OnboardingSlideView] = [
        ODisclaimerView(),
        OScanScinView(),
        OExploreSkinInsightsView(),
        OStayOnTrackView(),
        OChatView()
    ]
    
    private lazy var currentSlide = Slide.disclaimer
    
    private let didFinish: (() -> Void)
    private let didTapReadMore: (() -> Void)
    
    init(didFinish: @escaping (() -> Void), didTapReadMore: @escaping (() -> Void)) {
        self.didFinish = didFinish
        self.didTapReadMore = didTapReadMore
        
        super.init(frame: .zero)
        
        makeConstraints()
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
    
    func slideViewSkip() {
        didFinish()
    }
    
    func slideViewDidTapReadMore() {
        didTapReadMore()
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
                
                stepsView.update(at: slideView.slide)
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
        
        scrollToView.frame.origin = CGPoint(x: bounds.size.width * CGFloat(direction), y: 0)
        
        container.addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            currentView.frame.origin = CGPoint(x: bounds.size.width * CGFloat(-direction), y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { [weak self] result in
            guard let self = self else { return }
            
            currentView.removeFromSuperview()
            
            scrollToView.moveToThis()
            
            currentSlide = slide
            stepsView.update(at: slide)
        })
    }
}

// MARK: Make constraints
private extension OnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stepsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            stepsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            stepsView.heightAnchor.constraint(equalToConstant: 6.scale),
            stepsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 44.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStepsView() -> OStepsView {
        let view = OStepsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
