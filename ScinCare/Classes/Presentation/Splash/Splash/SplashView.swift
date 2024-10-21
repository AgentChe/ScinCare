//
//  SplashView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit

final class SplashView: UIView {
    lazy var imageView = makeImageView()
    lazy var preloader = makePreloader()
    lazy var preloaderLabel = makePreloaderLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension SplashView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 24.scale),
            preloader.heightAnchor.constraint(equalToConstant: 24.scale),
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.bottomAnchor.constraint(equalTo: preloaderLabel.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloaderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -26.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SplashView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage(named: "Splash.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.style = .medium
        view.startAnimating()
        view.color = Appearance.mono100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloaderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Roboto.medium(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Splash.Preloader".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
