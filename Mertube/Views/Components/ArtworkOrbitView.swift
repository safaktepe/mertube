//
//  ArtworkOrbitView.swift
//  Mertube
//

import UIKit

final class ArtworkOrbitView: UIView {
    private let carouselContainer = UIView()
    private let previousArtworkView = ArtworkImageView()
    private let currentArtworkView = ArtworkImageView()
    private let nextArtworkView = ArtworkImageView()
    private let ringOverlayView = UIView()
    private let glassBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let glassBlurMaskLayer = CAShapeLayer()
    private let glassGradientLayer = CAGradientLayer()
    private let glassMaskLayer = CAShapeLayer()
    private let outerStrokeLayer = CAShapeLayer()
    private let innerStrokeLayer = CAShapeLayer()
    private let highlightLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let touchIndicatorView = UIView()
    private let durationLabel = UILabel()
    private var artworkSize: CGFloat = 0

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
        artworkSize = bounds.width * 0.58
        carouselContainer.frame = bounds
        ringOverlayView.frame = bounds
        glassGradientLayer.frame = bounds
        previousArtworkView.frame = CGRect(
            x: center.x - artworkSize / 2 - bounds.width * 0.70,
            y: center.y - artworkSize / 2,
            width: artworkSize,
            height: artworkSize
        )
        currentArtworkView.frame = CGRect(
            x: center.x - artworkSize / 2,
            y: center.y - artworkSize / 2,
            width: artworkSize,
            height: artworkSize
        )
        nextArtworkView.frame = CGRect(
            x: center.x - artworkSize / 2 + bounds.width * 0.70,
            y: center.y - artworkSize / 2,
            width: artworkSize,
            height: artworkSize
        )
        touchIndicatorView.frame = CGRect(
            x: center.x - artworkSize * 0.16,
            y: center.y - artworkSize * 0.16,
            width: artworkSize * 0.32,
            height: artworkSize * 0.32
        )
        touchIndicatorView.layer.cornerRadius = touchIndicatorView.bounds.width / 2

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
        configure(previous: artwork, current: artwork, next: artwork, duration: duration)
    }

    func configure(previous: Artwork, current: Artwork, next: Artwork, duration: String) {
        previousArtworkView.configure(with: previous)
        currentArtworkView.configure(with: current)
        nextArtworkView.configure(with: next)
        durationLabel.text = duration
        carouselContainer.transform = .identity
        [previousArtworkView, currentArtworkView, nextArtworkView].forEach {
            $0.alpha = 1
            $0.transform = .identity
        }
        touchIndicatorView.alpha = 0
    }

    func setArtworkPressed(_ isPressed: Bool) {
        UIView.animate(
            withDuration: 0.16,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            self.currentArtworkView.transform = isPressed
                ? CGAffineTransform(scaleX: 0.94, y: 0.94)
                : .identity
            self.touchIndicatorView.alpha = isPressed ? 1 : 0
        }
    }

    func updateArtworkDrag(translationX: CGFloat) {
        let clampedTranslation = max(-bounds.width * 0.70, min(bounds.width * 0.70, translationX))
        let progress = min(1, abs(clampedTranslation) / (bounds.width * 0.55))
        carouselContainer.transform = CGAffineTransform(translationX: clampedTranslation, y: 0)
        currentArtworkView.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
        previousArtworkView.alpha = 0.70 + progress * 0.30
        nextArtworkView.alpha = 0.70 + progress * 0.30
        touchIndicatorView.alpha = 1 - progress * 0.55
    }

    func resetArtworkDrag() {
        UIView.animate(
            withDuration: 0.22,
            delay: 0,
            usingSpringWithDamping: 0.82,
            initialSpringVelocity: 0.20,
            options: [.allowUserInteraction]
        ) {
            self.carouselContainer.transform = .identity
            self.currentArtworkView.alpha = 1
            self.currentArtworkView.transform = .identity
            self.previousArtworkView.alpha = 1
            self.nextArtworkView.alpha = 1
            self.touchIndicatorView.alpha = 0
        }
    }

    func completeArtworkSwipe(direction: CGFloat, songChange: @escaping () -> Void, completion: @escaping () -> Void) {
        let normalizedDirection = direction >= 0 ? 1.0 : -1.0
        let snapTranslation = bounds.width * 0.70 * normalizedDirection

        UIView.animate(
            withDuration: 0.22,
            delay: 0,
            usingSpringWithDamping: 0.86,
            initialSpringVelocity: 0.35,
            options: [.allowUserInteraction]
        ) {
            self.carouselContainer.transform = CGAffineTransform(translationX: snapTranslation, y: 0)
            self.currentArtworkView.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
            self.touchIndicatorView.alpha = 0
        } completion: { _ in
            songChange()
            self.carouselContainer.transform = .identity
            self.currentArtworkView.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)

            UIView.animate(
                withDuration: 0.20,
                delay: 0,
                usingSpringWithDamping: 0.82,
                initialSpringVelocity: 0.35,
                options: [.allowUserInteraction]
            ) {
                self.currentArtworkView.transform = .identity
                self.previousArtworkView.alpha = 1
                self.nextArtworkView.alpha = 1
            } completion: { _ in
                completion()
            }
        }
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true

        carouselContainer.clipsToBounds = false
        addSubview(carouselContainer)

        [previousArtworkView, currentArtworkView, nextArtworkView].forEach {
            $0.layer.borderWidth = 0
            $0.layer.borderColor = UIColor.clear.cgColor
            carouselContainer.addSubview($0)
        }

        touchIndicatorView.backgroundColor = UIColor.white.withAlphaComponent(0.30)
        touchIndicatorView.layer.borderWidth = 1
        touchIndicatorView.layer.borderColor = UIColor.white.withAlphaComponent(0.45).cgColor
        touchIndicatorView.alpha = 0
        touchIndicatorView.isUserInteractionEnabled = false
        carouselContainer.addSubview(touchIndicatorView)

        ringOverlayView.isUserInteractionEnabled = false
        addSubview(ringOverlayView)

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
        ringOverlayView.layer.addSublayer(glassGradientLayer)
        ringOverlayView.addSubview(glassBlurView)

        outerStrokeLayer.strokeColor = UIColor.white.withAlphaComponent(0.46).cgColor
        outerStrokeLayer.fillColor = UIColor.clear.cgColor
        outerStrokeLayer.lineWidth = 1.4
        outerStrokeLayer.shadowColor = UIColor.white.cgColor
        outerStrokeLayer.shadowOpacity = 0.18
        outerStrokeLayer.shadowRadius = 7
        outerStrokeLayer.shadowOffset = .zero
        ringOverlayView.layer.addSublayer(outerStrokeLayer)

        innerStrokeLayer.strokeColor = UIColor.white.withAlphaComponent(0.13).cgColor
        innerStrokeLayer.fillColor = UIColor.clear.cgColor
        innerStrokeLayer.lineWidth = 1.2
        innerStrokeLayer.lineCap = .round
        ringOverlayView.layer.addSublayer(innerStrokeLayer)

        highlightLayer.strokeColor = UIColor.white.withAlphaComponent(0.34).cgColor
        highlightLayer.fillColor = UIColor.clear.cgColor
        highlightLayer.lineWidth = 2
        highlightLayer.lineCap = .round
        ringOverlayView.layer.addSublayer(highlightLayer)

        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.font = .monospacedDigitSystemFont(ofSize: 13, weight: .semibold)
        durationLabel.textColor = .white
        durationLabel.textAlignment = .center

        ringOverlayView.layer.addSublayer(progressLayer)

        progressLayer.strokeColor = UIColor(red: 0.54, green: 0.75, blue: 1, alpha: 0.88).cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 3
        progressLayer.lineCap = .round

        ringOverlayView.addSubview(durationLabel)

        NSLayoutConstraint.activate([
            glassBlurView.topAnchor.constraint(equalTo: topAnchor),
            glassBlurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            glassBlurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            glassBlurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
