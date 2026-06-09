//
//  SongCell.swift
//  Mertube
//

import UIKit

final class SongCell: UITableViewCell {
    static let reuseIdentifier = "SongCell"

    private let artworkView = ArtworkImageView()
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    private let durationLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(with song: Song) {
        artworkView.configure(with: song.artwork)
        titleLabel.text = song.title
        artistLabel.text = song.artist
        durationLabel.text = song.duration.mertubeDurationText
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        artworkView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .white
        artistLabel.font = .systemFont(ofSize: 14, weight: .medium)
        artistLabel.textColor = UIColor.white.withAlphaComponent(0.55)
        durationLabel.font = .monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        durationLabel.textColor = UIColor.white.withAlphaComponent(0.45)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false

        let textStack = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(artworkView)
        contentView.addSubview(textStack)
        contentView.addSubview(durationLabel)

        NSLayoutConstraint.activate([
            artworkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            artworkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artworkView.widthAnchor.constraint(equalToConstant: 48),
            artworkView.heightAnchor.constraint(equalTo: artworkView.widthAnchor),

            textStack.leadingAnchor.constraint(equalTo: artworkView.trailingAnchor, constant: 14),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: durationLabel.leadingAnchor, constant: -16),

            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            durationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
