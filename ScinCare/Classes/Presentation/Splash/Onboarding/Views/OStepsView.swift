//
//  OStepsView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 21.10.2024.
//

import UIKit

final class OStepsView: UIView {
    lazy var scanScinDivisionView = makeDivisionView()
    lazy var exploreSkinInsightsDivisionView = makeDivisionView()
    lazy var stayOnTrackDivisionView = makeDivisionView()
    lazy var chatDivisionView = makeDivisionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OStepsView {
    func update(at slide: OnboardingView.Slide) {
        let main100 = Appearance.main100
        let main200 = Appearance.main200
        
        scanScinDivisionView.backgroundColor = slide.equalOrGreater(than: .scanScin) ? main100 : main200
        exploreSkinInsightsDivisionView.backgroundColor = slide.equalOrGreater(than: .exploreSkinInsights) ? main100 : main200
        stayOnTrackDivisionView.backgroundColor = slide.equalOrGreater(than: .stayOnTrack) ? main100 : main200
        chatDivisionView.backgroundColor = slide.equalOrGreater(than: .chat) ? main100 : main200
        
        isHidden = {
            switch slide {
            case .disclaimer:
                return true
            case .scanScin, .exploreSkinInsights, .stayOnTrack, .chat:
                return false
            }
        }()
    }
}

// MARK: Private
private extension OStepsView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension OStepsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scanScinDivisionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scanScinDivisionView.topAnchor.constraint(equalTo: topAnchor),
            scanScinDivisionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scanScinDivisionView.widthAnchor.constraint(equalTo: exploreSkinInsightsDivisionView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            exploreSkinInsightsDivisionView.leadingAnchor.constraint(equalTo: scanScinDivisionView.trailingAnchor, constant: 6.scale),
            exploreSkinInsightsDivisionView.topAnchor.constraint(equalTo: topAnchor),
            exploreSkinInsightsDivisionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            exploreSkinInsightsDivisionView.widthAnchor.constraint(equalTo: stayOnTrackDivisionView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stayOnTrackDivisionView.leadingAnchor.constraint(equalTo: exploreSkinInsightsDivisionView.trailingAnchor, constant: 6.scale),
            stayOnTrackDivisionView.topAnchor.constraint(equalTo: topAnchor),
            stayOnTrackDivisionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stayOnTrackDivisionView.widthAnchor.constraint(equalTo: chatDivisionView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            chatDivisionView.leadingAnchor.constraint(equalTo: stayOnTrackDivisionView.trailingAnchor, constant: 6.scale),
            chatDivisionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chatDivisionView.topAnchor.constraint(equalTo: topAnchor),
            chatDivisionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OStepsView {
    func makeDivisionView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 2.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension OnboardingView.Slide {
    func equalOrGreater(than slide: OnboardingView.Slide) -> Bool {
        rawValue >= slide.rawValue
    }
}
