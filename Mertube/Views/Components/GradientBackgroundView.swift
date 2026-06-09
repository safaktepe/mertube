//
//  GradientBackgroundView.swift
//  Mertube
//

import UIKit

final class GradientBackgroundView: UIView {
    private let gradientLayer = CAGradientLayer()

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
    }

    private func setupView() {
        layer.addSublayer(gradientLayer)
        gradientLayer.colors = [
            UIColor(red: 0.24, green: 0.08, blue: 0.35, alpha: 1).cgColor,
            UIColor(red: 0.28, green: 0.10, blue: 0.40, alpha: 1).cgColor,
            UIColor(red: 0.22, green: 0.07, blue: 0.32, alpha: 1).cgColor,
            UIColor(red: 0.15, green: 0.04, blue: 0.21, alpha: 1).cgColor,
            UIColor(red: 0.08, green: 0.02, blue: 0.11, alpha: 1).cgColor,
            UIColor(red: 0.02, green: 0.005, blue: 0.03, alpha: 1).cgColor,
            UIColor.black.cgColor,
            UIColor.black.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.locations = [0, 0.18, 0.34, 0.46, 0.54, 0.60, 0.66, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
}
