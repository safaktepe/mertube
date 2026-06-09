//
//  PlaylistCell.swift
//  Mertube
//

import UIKit

final class PlaylistCell: UITableViewCell {
    static let reuseIdentifier = "PlaylistCell"

    private let artworkView = ArtworkImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(with playlist: Playlist) {
        artworkView.configure(with: playlist.artwork)
        titleLabel.text = playlist.title
        subtitleLabel.text = playlist.subtitle
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        artworkView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.58)
        chevronImageView.tintColor = UIColor.white.withAlphaComponent(0.45)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(artworkView)
        contentView.addSubview(textStack)
        contentView.addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            artworkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            artworkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artworkView.widthAnchor.constraint(equalToConstant: 58),
            artworkView.heightAnchor.constraint(equalTo: artworkView.widthAnchor),

            textStack.leadingAnchor.constraint(equalTo: artworkView.trailingAnchor, constant: 16),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -16),

            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 14),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
