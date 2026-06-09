//
//  ArtworkImageView.swift
//  Mertube
//

import UIKit

final class ArtworkImageView: UIView {
    enum Shape {
        case circle
        case rounded(CGFloat)
    }

    private let gradientLayer = CAGradientLayer()
    private let symbolImageView = UIImageView()
    var shape: Shape = .circle {
        didSet {
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        switch shape {
        case .circle:
            layer.cornerRadius = bounds.width / 2
        case .rounded(let radius):
            layer.cornerRadius = radius
        }
    }

    func configure(with artwork: Artwork) {
        gradientLayer.colors = artwork.colors.map(\.cgColor)
        symbolImageView.image = UIImage(systemName: artwork.symbolName)
    }

    private func setupView() {
        clipsToBounds = true
        layer.addSublayer(gradientLayer)
        gradientLayer.startPoint = CGPoint(x: 0.1, y: 0.1)
        gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.95)

        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFit
        symbolImageView.tintColor = UIColor.white.withAlphaComponent(0.9)
        addSubview(symbolImageView)

        NSLayoutConstraint.activate([
            symbolImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            symbolImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            symbolImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.42),
            symbolImageView.heightAnchor.constraint(equalTo: symbolImageView.widthAnchor)
        ])
    }
}
