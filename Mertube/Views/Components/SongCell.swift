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
    private let separatorView = UIView()

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
        artworkView.shape = .rounded(14)
        titleLabel.font = .systemFont(ofSize: 19, weight: .semibold)
        titleLabel.textColor = .white
        artistLabel.font = .systemFont(ofSize: 15, weight: .medium)
        artistLabel.textColor = UIColor.white.withAlphaComponent(0.54)
        durationLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        durationLabel.textColor = UIColor.white.withAlphaComponent(0.42)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.white.withAlphaComponent(0.10)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        textStack.axis = .vertical
        textStack.spacing = 7
        textStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(artworkView)
        contentView.addSubview(textStack)
        contentView.addSubview(durationLabel)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            artworkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            artworkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artworkView.widthAnchor.constraint(equalToConstant: 62),
            artworkView.heightAnchor.constraint(equalTo: artworkView.widthAnchor),

            textStack.leadingAnchor.constraint(equalTo: artworkView.trailingAnchor, constant: 17),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: durationLabel.leadingAnchor, constant: -16),

            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            durationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            separatorView.leadingAnchor.constraint(equalTo: textStack.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }
}
