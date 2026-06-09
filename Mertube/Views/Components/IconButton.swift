//
//  IconButton.swift
//  Mertube
//

import UIKit

final class IconButton: UIButton {
    init(systemName: String, pointSize: CGFloat = 20) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = .white
        setImage(UIImage(systemName: systemName), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: pointSize, weight: .semibold),
            forImageIn: .normal
        )
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
