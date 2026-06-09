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
            UIColor(red: 0.08, green: 0.01, blue: 0.08, alpha: 1).cgColor,
            UIColor(red: 0.33, green: 0.16, blue: 0.45, alpha: 1).cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.locations = [0, 0.45, 1]
        gradientLayer.startPoint = CGPoint(x: 0.2, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.85, y: 1)
    }
}
