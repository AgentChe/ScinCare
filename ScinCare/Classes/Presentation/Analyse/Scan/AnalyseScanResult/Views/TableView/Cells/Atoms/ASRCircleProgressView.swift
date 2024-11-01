//
//  ASRCircleProgressView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 01.11.2024.
//

import UIKit

final class ASRCircleProgressView: UIView {
    lazy var label = makeLabel()
    
    private lazy var circleLayer = CAShapeLayer()
    private lazy var trackLayer = CAShapeLayer()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Roboto.bold(size: 11.scale))
        .textAlignment(.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createCircularPath()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ASRCircleProgressView {
    func setup(progress: Double) {
        trackLayer.strokeEnd = CGFloat(progress)
        
        let string = String(format: "%i%%", Int(progress * 100))
        label.attributedText = string.attributed(with: attrs)
    }
}

// MARK: Private
private extension ASRCircleProgressView {
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 19.scale, y: 19.scale),
                                        radius: 17.scale,
                                        startAngle: -.pi / 2,
                                        endAngle: 1.5 * .pi,
                                        clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 4.scale
        circleLayer.strokeColor = Appearance.main100.withAlphaComponent(0.2).cgColor
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        trackLayer.lineWidth = 4.scale
        trackLayer.strokeColor = Appearance.main100.cgColor
        trackLayer.strokeStart = 0
        
        layer.addSublayer(circleLayer)
        layer.addSublayer(trackLayer)
    }
}

// MARK: Make constraints
private extension ASRCircleProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ASRCircleProgressView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
