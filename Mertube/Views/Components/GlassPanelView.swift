//
//  GlassPanelView.swift
//  Mertube
//

import UIKit

final class GlassPanelView: UIVisualEffectView {
    init(cornerRadius: CGFloat = 28) {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        super.init(effect: blur)
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.20).cgColor
        backgroundColor = UIColor.white.withAlphaComponent(0.035)
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.025)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
