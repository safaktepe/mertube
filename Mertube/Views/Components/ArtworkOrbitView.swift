//
//  ArtworkOrbitView.swift
//  Mertube
//

import UIKit

final class ArtworkOrbitView: UIView {
    private let glassBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let glassBlurMaskLayer = CAShapeLayer()
    private let glassGradientLayer = CAGradientLayer()
    private let glassMaskLayer = CAShapeLayer()
    private let outerStrokeLayer = CAShapeLayer()
    private let innerStrokeLayer = CAShapeLayer()
    private let highlightLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let artworkView = ArtworkImageView()
    private let durationLabel = UILabel()

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
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let artworkRadius = bounds.width * 0.29
        let outerRadius = bounds.width * 0.49
        let ringInnerRadius = artworkRadius - 1
        let innerLineRadius = (artworkRadius + outerRadius) / 2

        durationLabel.sizeToFit()
        glassGradientLayer.frame = bounds

        let ringPath = UIBezierPath(
            arcCenter: center,
            radius: outerRadius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )
        ringPath.append(UIBezierPath(
            arcCenter: center,
            radius: ringInnerRadius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: false
        ))
        glassMaskLayer.path = ringPath.cgPath
        glassMaskLayer.fillRule = .evenOdd
        glassBlurMaskLayer.path = ringPath.cgPath
        glassBlurMaskLayer.fillRule = .evenOdd

        outerStrokeLayer.path = UIBezierPath(
            arcCenter: center,
            radius: outerRadius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        ).cgPath

        innerStrokeLayer.path = bottomGapCirclePath(
            center: center,
            radius: innerLineRadius,
            labelWidth: durationLabel.bounds.width + 22
        ).cgPath

        highlightLayer.path = UIBezierPath(
            arcCenter: center,
            radius: outerRadius - 1.5,
            startAngle: .pi * 1.05,
            endAngle: .pi * 1.92,
            clockwise: true
        ).cgPath

        progressLayer.path = UIBezierPath(
            arcCenter: center,
            radius: innerLineRadius,
            startAngle: .pi * 0.62,
            endAngle: .pi * 0.78,
            clockwise: true
        ).cgPath

        durationLabel.center = CGPoint(x: center.x, y: center.y + innerLineRadius)
    }

    private func bottomGapCirclePath(center: CGPoint, radius: CGFloat, labelWidth: CGFloat) -> UIBezierPath {
        let halfGapAngle = max(0.20, min(0.42, asin(min(0.92, labelWidth / 2 / radius)) + 0.08))
        let bottomAngle = CGFloat.pi / 2
        let path = UIBezierPath()

        path.addArc(
            withCenter: center,
            radius: radius,
            startAngle: bottomAngle + halfGapAngle,
            endAngle: bottomAngle - halfGapAngle + .pi * 2,
            clockwise: true
        )

        return path
    }

    func configure(with artwork: Artwork, duration: String) {
        artworkView.configure(with: artwork)
        durationLabel.text = duration
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false

        glassBlurView.translatesAutoresizingMaskIntoConstraints = false
        glassBlurView.alpha = 0.22
        glassBlurView.layer.mask = glassBlurMaskLayer

        glassGradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.16).cgColor,
            UIColor.white.withAlphaComponent(0.045).cgColor,
            UIColor.black.withAlphaComponent(0.045).cgColor,
            UIColor.white.withAlphaComponent(0.075).cgColor
        ]
        glassGradientLayer.locations = [0, 0.32, 0.72, 1]
        glassGradientLayer.startPoint = CGPoint(x: 0.12, y: 0)
        glassGradientLayer.endPoint = CGPoint(x: 0.90, y: 1)
        glassGradientLayer.mask = glassMaskLayer
        layer.addSublayer(glassGradientLayer)
        addSubview(glassBlurView)

        outerStrokeLayer.strokeColor = UIColor.white.withAlphaComponent(0.46).cgColor
        outerStrokeLayer.fillColor = UIColor.clear.cgColor
        outerStrokeLayer.lineWidth = 1.4
        outerStrokeLayer.shadowColor = UIColor.white.cgColor
        outerStrokeLayer.shadowOpacity = 0.18
        outerStrokeLayer.shadowRadius = 7
        outerStrokeLayer.shadowOffset = .zero
        layer.addSublayer(outerStrokeLayer)

        innerStrokeLayer.strokeColor = UIColor.white.withAlphaComponent(0.13).cgColor
        innerStrokeLayer.fillColor = UIColor.clear.cgColor
        innerStrokeLayer.lineWidth = 1.2
        innerStrokeLayer.lineCap = .round
        layer.addSublayer(innerStrokeLayer)

        highlightLayer.strokeColor = UIColor.white.withAlphaComponent(0.34).cgColor
        highlightLayer.fillColor = UIColor.clear.cgColor
        highlightLayer.lineWidth = 2
        highlightLayer.lineCap = .round
        layer.addSublayer(highlightLayer)

        artworkView.translatesAutoresizingMaskIntoConstraints = false
        artworkView.layer.borderWidth = 0
        artworkView.layer.borderColor = UIColor.clear.cgColor

        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.font = .monospacedDigitSystemFont(ofSize: 13, weight: .semibold)
        durationLabel.textColor = .white
        durationLabel.textAlignment = .center

        layer.addSublayer(progressLayer)

        progressLayer.strokeColor = UIColor(red: 0.54, green: 0.75, blue: 1, alpha: 0.88).cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 3
        progressLayer.lineCap = .round

        addSubview(artworkView)
        addSubview(durationLabel)

        NSLayoutConstraint.activate([
            glassBlurView.topAnchor.constraint(equalTo: topAnchor),
            glassBlurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            glassBlurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            glassBlurView.bottomAnchor.constraint(equalTo: bottomAnchor),

            artworkView.centerXAnchor.constraint(equalTo: centerXAnchor),
            artworkView.centerYAnchor.constraint(equalTo: centerYAnchor),
            artworkView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.58),
            artworkView.heightAnchor.constraint(equalTo: artworkView.widthAnchor)
        ])
    }
}
