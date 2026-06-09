//
//  GlassPanelView.swift
//  Mertube
//

import UIKit

final class GlassPanelView: UIVisualEffectView {
    private let tintLayer = CAGradientLayer()

    init(cornerRadius: CGFloat = 28) {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        super.init(effect: blur)
        setupGlass(cornerRadius: cornerRadius)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGlass(cornerRadius: 28)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tintLayer.frame = contentView.bounds
        tintLayer.cornerRadius = layer.cornerRadius
    }

    private func setupGlass(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.58, green: 0.62, blue: 0.82, alpha: 0.20).cgColor
        backgroundColor = UIColor.black.withAlphaComponent(0.18)
        contentView.backgroundColor = .clear

        tintLayer.colors = [
            UIColor.white.withAlphaComponent(0.08).cgColor,
            UIColor(red: 0.05, green: 0.07, blue: 0.14, alpha: 0.64).cgColor,
            UIColor(red: 0.09, green: 0.08, blue: 0.20, alpha: 0.50).cgColor,
            UIColor.black.withAlphaComponent(0.38).cgColor
        ]
        tintLayer.locations = [0, 0.22, 0.72, 1]
        tintLayer.startPoint = CGPoint(x: 0.12, y: 0)
        tintLayer.endPoint = CGPoint(x: 0.88, y: 1)
        tintLayer.cornerCurve = .continuous
        contentView.layer.insertSublayer(tintLayer, at: 0)
    }
}
