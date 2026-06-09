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
        layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
