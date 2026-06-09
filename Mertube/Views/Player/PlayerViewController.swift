//
//  PlayerViewController.swift
//  Mertube
//

import UIKit

final class PlayerViewController: UIViewController {
    var onSongChanged: ((Song) -> Void)?

    private let viewModel: PlayerViewModel

    private let backgroundView = PlayerBackdropView()
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    private let orbitView = ArtworkOrbitView()
    private let previousArtworkView = SideArtworkGlassView()
    private let nextArtworkView = SideArtworkGlassView()
    private let playButton = IconButton(systemName: "pause.fill", pointSize: 34)
    private let bottomBar = GlassPanelView(cornerRadius: 34)

    init(viewModel: PlayerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        render()
    }

    private func setupView() {
        view.backgroundColor = .black
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)

        let collapseButton = IconButton(systemName: "chevron.down", pointSize: 18)
        collapseButton.addTarget(self, action: #selector(dismissPlayer), for: .touchUpInside)

        let menuButton = IconButton(systemName: "ellipsis", pointSize: 24)
        let favoriteButton = IconButton(systemName: "heart", pointSize: 25)

        titleLabel.font = .systemFont(ofSize: 35, weight: .light)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        artistLabel.font = .systemFont(ofSize: 18, weight: .medium)
        artistLabel.textColor = UIColor.white.withAlphaComponent(0.65)

        [previousArtworkView, nextArtworkView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        previousArtworkView.alpha = 0.78
        nextArtworkView.alpha = 0.86

        let titleStack = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        titleStack.axis = .vertical
        titleStack.spacing = 4
        titleStack.translatesAutoresizingMaskIntoConstraints = false

        let previousButton = IconButton(systemName: "backward.fill", pointSize: 24)
        let nextButton = IconButton(systemName: "forward.fill", pointSize: 24)
        let shuffleButton = IconButton(systemName: "shuffle", pointSize: 18)
        let repeatButton = IconButton(systemName: "repeat", pointSize: 18)
        previousButton.addTarget(self, action: #selector(playPrevious), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(playNext), for: .touchUpInside)

        let controlsStack = UIStackView(arrangedSubviews: [shuffleButton, previousButton, playButton, nextButton, repeatButton])
        controlsStack.axis = .horizontal
        controlsStack.alignment = .center
        controlsStack.distribution = .equalSpacing
        controlsStack.translatesAutoresizingMaskIntoConstraints = false

        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        let bottomHome = IconButton(systemName: "house", pointSize: 22)
        let bottomList = IconButton(systemName: "music.note.list", pointSize: 22)
        let bottomBell = IconButton(systemName: "bell", pointSize: 21)
        let bottomStack = UIStackView(arrangedSubviews: [bottomHome, bottomList, bottomBell])
        bottomStack.axis = .horizontal
        bottomStack.alignment = .center
        bottomStack.distribution = .equalSpacing
        bottomStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collapseButton)
        view.addSubview(menuButton)
        view.addSubview(favoriteButton)
        view.addSubview(titleStack)
        view.addSubview(previousArtworkView)
        view.addSubview(nextArtworkView)
        view.addSubview(orbitView)
        view.addSubview(controlsStack)
        view.addSubview(bottomBar)
        bottomBar.contentView.addSubview(bottomStack)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            collapseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collapseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collapseButton.widthAnchor.constraint(equalToConstant: 48),
            collapseButton.heightAnchor.constraint(equalToConstant: 44),

            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 78),
            menuButton.widthAnchor.constraint(equalToConstant: 48),
            menuButton.heightAnchor.constraint(equalToConstant: 48),

            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            favoriteButton.topAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: 32),
            favoriteButton.widthAnchor.constraint(equalToConstant: 48),
            favoriteButton.heightAnchor.constraint(equalToConstant: 48),

            titleStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 46),
            titleStack.trailingAnchor.constraint(lessThanOrEqualTo: menuButton.leadingAnchor, constant: -18),
            titleStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),

            orbitView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orbitView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -34),
            orbitView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.74),
            orbitView.heightAnchor.constraint(equalTo: orbitView.widthAnchor),

            previousArtworkView.trailingAnchor.constraint(equalTo: orbitView.leadingAnchor, constant: 20),
            previousArtworkView.centerYAnchor.constraint(equalTo: orbitView.centerYAnchor),
            previousArtworkView.widthAnchor.constraint(equalTo: orbitView.widthAnchor, multiplier: 0.34),
            previousArtworkView.heightAnchor.constraint(equalTo: previousArtworkView.widthAnchor),

            nextArtworkView.leadingAnchor.constraint(equalTo: orbitView.trailingAnchor, constant: -20),
            nextArtworkView.centerYAnchor.constraint(equalTo: orbitView.centerYAnchor),
            nextArtworkView.widthAnchor.constraint(equalTo: orbitView.widthAnchor, multiplier: 0.34),
            nextArtworkView.heightAnchor.constraint(equalTo: nextArtworkView.widthAnchor),

            controlsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            controlsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            controlsStack.topAnchor.constraint(equalTo: orbitView.bottomAnchor, constant: 30),
            controlsStack.heightAnchor.constraint(equalToConstant: 54),

            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 34),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -34),
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            bottomBar.heightAnchor.constraint(equalToConstant: 74),

            bottomStack.leadingAnchor.constraint(equalTo: bottomBar.contentView.leadingAnchor, constant: 34),
            bottomStack.trailingAnchor.constraint(equalTo: bottomBar.contentView.trailingAnchor, constant: -34),
            bottomStack.centerYAnchor.constraint(equalTo: bottomBar.contentView.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.onChange = { [weak self] in
            self?.render()
        }
    }

    private func render() {
        titleLabel.text = viewModel.currentSong.title
        artistLabel.text = viewModel.currentSong.artist
        backgroundView.configure(with: viewModel.currentSong.artwork)
        orbitView.configure(with: viewModel.currentSong.artwork, duration: viewModel.durationText)
        previousArtworkView.configure(with: viewModel.previousSong.artwork)
        nextArtworkView.configure(with: viewModel.nextSong.artwork)
        onSongChanged?(viewModel.currentSong)
    }

    @objc private func dismissPlayer() {
        dismiss(animated: true)
    }

    @objc private func playPrevious() {
        viewModel.playPrevious()
    }

    @objc private func playNext() {
        viewModel.playNext()
    }
}
