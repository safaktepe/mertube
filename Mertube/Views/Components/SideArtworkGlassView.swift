//
//  SideArtworkGlassView.swift
//  Mertube
//

import UIKit

final class SideArtworkGlassView: UIView {
    private let artworkView = ArtworkImageView()
    private let glassOverlay = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
    private let edgeHighlightLayer = CAGradientLayer()
    private let chromaticLayer = CAGradientLayer()

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
        layer.cornerRadius = bounds.width / 2
        glassOverlay.layer.cornerRadius = bounds.width / 2
        edgeHighlightLayer.cornerRadius = bounds.width / 2
        chromaticLayer.cornerRadius = (bounds.width + 4) / 2
        edgeHighlightLayer.frame = bounds
        chromaticLayer.frame = bounds.insetBy(dx: -2, dy: -2)
    }

    func configure(with artwork: Artwork) {
        artworkView.configure(with: artwork)
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = false
        alpha = 0.9

        artworkView.translatesAutoresizingMaskIntoConstraints = false
        artworkView.transform = CGAffineTransform(scaleX: 1.05, y: 0.95)

        glassOverlay.translatesAutoresizingMaskIntoConstraints = false
        glassOverlay.isUserInteractionEnabled = false
        glassOverlay.alpha = 0.18
        glassOverlay.clipsToBounds = true

        edgeHighlightLayer.colors = [
            UIColor.white.withAlphaComponent(0.72).cgColor,
            UIColor.white.withAlphaComponent(0.08).cgColor,
            UIColor.black.withAlphaComponent(0.10).cgColor
        ]
        edgeHighlightLayer.locations = [0, 0.42, 1]
        edgeHighlightLayer.startPoint = CGPoint(x: 0.12, y: 0.06)
        edgeHighlightLayer.endPoint = CGPoint(x: 0.94, y: 0.94)
        edgeHighlightLayer.borderWidth = 1.2
        edgeHighlightLayer.borderColor = UIColor.white.withAlphaComponent(0.24).cgColor

        chromaticLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.24).cgColor,
            UIColor.clear.cgColor,
            UIColor.systemPink.withAlphaComponent(0.18).cgColor
        ]
        chromaticLayer.locations = [0, 0.55, 1]
        chromaticLayer.startPoint = CGPoint(x: 0, y: 0)
        chromaticLayer.endPoint = CGPoint(x: 1, y: 1)
        chromaticLayer.opacity = 0.75

        addSubview(artworkView)
        addSubview(glassOverlay)
        layer.addSublayer(chromaticLayer)
        layer.addSublayer(edgeHighlightLayer)

        NSLayoutConstraint.activate([
            artworkView.topAnchor.constraint(equalTo: topAnchor),
            artworkView.leadingAnchor.constraint(equalTo: leadingAnchor),
            artworkView.trailingAnchor.constraint(equalTo: trailingAnchor),
            artworkView.bottomAnchor.constraint(equalTo: bottomAnchor),

            glassOverlay.topAnchor.constraint(equalTo: topAnchor),
            glassOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            glassOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            glassOverlay.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
