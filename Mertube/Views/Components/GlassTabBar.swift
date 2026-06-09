//
//  GlassTabBar.swift
//  Mertube
//

import UIKit

final class GlassTabBar: UIView {
    var selectedIndex: Int = 0 {
        didSet {
            updateSelection()
        }
    }

    var onSelect: ((Int) -> Void)?

    private let panelView = GlassPanelView(cornerRadius: 34)
    private let stackView = UIStackView()
    private let centerArtworkView = ArtworkImageView()
    private var buttons: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configureArtwork(_ artwork: Artwork) {
        centerArtworkView.configure(with: artwork)
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        panelView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(panelView)

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        panelView.contentView.addSubview(stackView)

        let items = ["house", "music.note.list", "gearshape"]
        buttons = items.enumerated().map { index, symbol in
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.tintColor = UIColor.white.withAlphaComponent(0.5)
            button.setImage(UIImage(systemName: symbol), for: .normal)
            button.setPreferredSymbolConfiguration(
                UIImage.SymbolConfiguration(pointSize: 21, weight: .semibold),
                forImageIn: .normal
            )
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 48).isActive = true
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            return button
        }

        centerArtworkView.translatesAutoresizingMaskIntoConstraints = false
        centerArtworkView.layer.borderWidth = 2
        centerArtworkView.layer.borderColor = UIColor.white.withAlphaComponent(0.18).cgColor

        stackView.addArrangedSubview(buttons[0])
        stackView.addArrangedSubview(buttons[1])
        stackView.addArrangedSubview(centerArtworkView)
        stackView.addArrangedSubview(buttons[2])

        NSLayoutConstraint.activate([
            panelView.topAnchor.constraint(equalTo: topAnchor),
            panelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            panelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            panelView.bottomAnchor.constraint(equalTo: bottomAnchor),
            panelView.heightAnchor.constraint(equalToConstant: 72),

            stackView.leadingAnchor.constraint(equalTo: panelView.contentView.leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: panelView.contentView.trailingAnchor, constant: -22),
            stackView.centerYAnchor.constraint(equalTo: panelView.contentView.centerYAnchor),

            centerArtworkView.widthAnchor.constraint(equalToConstant: 46),
            centerArtworkView.heightAnchor.constraint(equalTo: centerArtworkView.widthAnchor)
        ])

        configureArtwork(.bloom)
        updateSelection()
    }

    @objc private func didTapButton(_ sender: UIButton) {
        selectedIndex = sender.tag
        onSelect?(sender.tag)
    }

    private func updateSelection() {
        buttons.forEach { button in
            button.tintColor = button.tag == selectedIndex ? .white : UIColor.white.withAlphaComponent(0.45)
        }
    }
}
