//
//  PlayerBackdropView.swift
//  Mertube
//

import UIKit

final class PlayerBackdropView: UIView {
    private let baseGradientLayer = CAGradientLayer()
    private let glowLayer = CAGradientLayer()
    private let sideShadeLayer = CAGradientLayer()

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
        baseGradientLayer.frame = bounds
        glowLayer.frame = CGRect(
            x: bounds.minX - bounds.width * 0.12,
            y: bounds.minY - bounds.height * 0.08,
            width: bounds.width * 1.24,
            height: bounds.height * 0.58
        )
        sideShadeLayer.frame = bounds
    }

    func configure(with artwork: Artwork, animated: Bool = true) {
        let colors = artwork.colors
        let first = colors[safe: 0] ?? .systemPurple
        let second = colors[safe: 1] ?? first
        let third = colors[safe: 2] ?? second

        let baseColors = [
            first.adjusted(brightness: 0.62, saturation: 0.80).cgColor,
            second.adjusted(brightness: 0.42, saturation: 0.72).cgColor,
            UIColor(red: 0.05, green: 0.02, blue: 0.06, alpha: 1).cgColor,
            UIColor.black.cgColor,
            UIColor.black.cgColor
        ]

        let glowColors = [
            third.withAlphaComponent(0.54).cgColor,
            second.withAlphaComponent(0.25).cgColor,
            UIColor.clear.cgColor
        ]

        update(layer: baseGradientLayer, keyPath: "colors", value: baseColors, animated: animated)
        update(layer: glowLayer, keyPath: "colors", value: glowColors, animated: animated)
    }

    private func setupView() {
        backgroundColor = .black

        baseGradientLayer.startPoint = CGPoint(x: 0.46, y: 0)
        baseGradientLayer.endPoint = CGPoint(x: 0.50, y: 1)
        baseGradientLayer.locations = [0, 0.27, 0.48, 0.62, 1]
        layer.addSublayer(baseGradientLayer)

        glowLayer.type = .radial
        glowLayer.startPoint = CGPoint(x: 0.62, y: 0.08)
        glowLayer.endPoint = CGPoint(x: 1, y: 1)
        glowLayer.locations = [0, 0.48, 1]
        glowLayer.opacity = 0.95
        layer.addSublayer(glowLayer)

        sideShadeLayer.colors = [
            UIColor.black.withAlphaComponent(0.34).cgColor,
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.50).cgColor
        ]
        sideShadeLayer.locations = [0, 0.42, 1]
        sideShadeLayer.startPoint = CGPoint(x: 0, y: 0.2)
        sideShadeLayer.endPoint = CGPoint(x: 1, y: 0.85)
        layer.addSublayer(sideShadeLayer)

        configure(with: .bloom, animated: false)
    }

    private func update(layer: CALayer, keyPath: String, value: Any, animated: Bool) {
        if animated {
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.fromValue = layer.presentation()?.value(forKeyPath: keyPath) ?? layer.value(forKeyPath: keyPath)
            animation.toValue = value
            animation.duration = 0.38
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            layer.add(animation, forKey: keyPath)
        }
        layer.setValue(value, forKeyPath: keyPath)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

private extension UIColor {
    func adjusted(brightness: CGFloat, saturation: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var currentSaturation: CGFloat = 0
        var currentBrightness: CGFloat = 0
        var alpha: CGFloat = 0

        guard getHue(&hue, saturation: &currentSaturation, brightness: &currentBrightness, alpha: &alpha) else {
            return self
        }

        return UIColor(
            hue: hue,
            saturation: min(1, currentSaturation * saturation),
            brightness: min(1, currentBrightness * brightness),
            alpha: alpha
        )
    }
}
