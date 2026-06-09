//
//  MainTabBarController.swift
//  Mertube
//

import UIKit

final class MainTabBarController: UIViewController {
    private let libraryViewModel = LibraryViewModel()
    private let contentContainer = UIView()
    private let glassTabBar = GlassTabBar()
    private let miniPlayerView = MiniPlayerView()

    private lazy var homeController = HomeViewController(viewModel: libraryViewModel)
    private lazy var nowPlayingController = NowPlayingPlaceholderViewController()
    private lazy var settingsController = SettingsViewController()
    private var currentController: UIViewController?
    private var playerViewModel: PlayerViewModel?
    private var playerController: PlayerViewController?
    private var playerTopConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupChildren()
        showPage(at: 0)
    }

    private func setupView() {
        view.backgroundColor = .black
        let backgroundView = GradientBackgroundView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        miniPlayerView.translatesAutoresizingMaskIntoConstraints = false
        miniPlayerView.alpha = 0
        miniPlayerView.isHidden = true

        view.addSubview(backgroundView)
        view.addSubview(contentContainer)
        view.addSubview(glassTabBar)
        view.addSubview(miniPlayerView)

        glassTabBar.onSelect = { [weak self] index in
            self?.showPage(at: index)
        }
        miniPlayerView.onTap = { [weak self] in
            self?.expandPlayer()
        }
        miniPlayerView.onPrevious = { [weak self] in
            self?.playerViewModel?.playPrevious()
        }
        miniPlayerView.onNext = { [weak self] in
            self?.playerViewModel?.playNext()
        }

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentContainer.topAnchor.constraint(equalTo: view.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            glassTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            glassTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            glassTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            miniPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            miniPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            miniPlayerView.bottomAnchor.constraint(equalTo: glassTabBar.topAnchor, constant: -12),
            miniPlayerView.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    private func setupChildren() {
        homeController.onPlaylistSelected = { [weak self] playlist in
            self?.showPlaylist(playlist)
        }

        homeController.onSongSelected = { [weak self] songs, song in
            self?.presentPlayer(songs: songs, selectedSong: song)
        }
    }

    private func showPage(at index: Int) {
        glassTabBar.selectedIndex = index
        let controller: UIViewController
        switch index {
        case 0:
            controller = homeController
        case 1:
            controller = nowPlayingController
        default:
            controller = settingsController
        }

        transition(to: controller)
    }

    private func transition(to controller: UIViewController) {
        guard currentController !== controller else { return }

        currentController?.willMove(toParent: nil)
        currentController?.view.removeFromSuperview()
        currentController?.removeFromParent()

        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(controller.view)

        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            controller.view.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
        ])

        controller.didMove(toParent: self)
        currentController = controller
    }

    private func showPlaylist(_ playlist: Playlist) {
        let viewModel = PlaylistDetailViewModel(playlist: playlist)
        let detailController = PlaylistDetailViewController(viewModel: viewModel)
        detailController.onSongSelected = { [weak self] songs, song in
            self?.presentPlayer(songs: songs, selectedSong: song)
        }
        homeController.pushViewController(detailController, animated: true)
    }

    private func presentPlayer(songs: [Song], selectedSong: Song) {
        let viewModel = PlayerViewModel(songs: songs, selectedSong: selectedSong)
        playerViewModel = viewModel
        glassTabBar.configureArtwork(selectedSong.artwork)

        if let playerController {
            playerTopConstraint?.isActive = false
            playerTopConstraint = nil
            playerController.willMove(toParent: nil)
            playerController.view.removeFromSuperview()
            playerController.removeFromParent()
        }

        let playerController = PlayerViewController(viewModel: viewModel)
        playerController.onSongChanged = { [weak self] song in
            self?.glassTabBar.configureArtwork(song.artwork)
            self?.miniPlayerView.configure(with: song)
        }
        playerController.onCollapse = { [weak self] in
            self?.collapsePlayer()
        }
        self.playerController = playerController
        miniPlayerView.configure(with: selectedSong)

        addChild(playerController)
        playerController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerController.view)
        let topConstraint = playerController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height)
        playerTopConstraint = topConstraint

        NSLayoutConstraint.activate([
            topConstraint,
            playerController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerController.view.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        playerController.didMove(toParent: self)
        view.layoutIfNeeded()
        expandPlayer()
    }

    private func collapsePlayer() {
        guard let playerView = playerController?.view else { return }

        miniPlayerView.isHidden = false
        view.bringSubviewToFront(miniPlayerView)
        view.bringSubviewToFront(playerView)
        playerTopConstraint?.constant = view.bounds.height

        UIView.animate(
            withDuration: 0.58,
            delay: 0,
            usingSpringWithDamping: 0.92,
            initialSpringVelocity: 0.35,
            options: [.curveEaseInOut, .allowUserInteraction]
        ) {
            self.miniPlayerView.alpha = 1
            self.miniPlayerView.transform = .identity
            self.view.layoutIfNeeded()
        }
    }

    private func expandPlayer() {
        guard let playerView = playerController?.view else { return }

        view.bringSubviewToFront(playerView)
        playerTopConstraint?.constant = 0

        UIView.animate(
            withDuration: 0.62,
            delay: 0,
            usingSpringWithDamping: 0.90,
            initialSpringVelocity: 0.28,
            options: [.curveEaseInOut, .allowUserInteraction]
        ) {
            self.miniPlayerView.alpha = 0
            self.miniPlayerView.transform = CGAffineTransform(translationX: 0, y: 10)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.miniPlayerView.isHidden = true
            self.miniPlayerView.transform = .identity
        }
    }
}

private final class MiniPlayerView: UIView, UIGestureRecognizerDelegate {
    var onTap: (() -> Void)?
    var onPrevious: (() -> Void)?
    var onNext: (() -> Void)?

    private let panelView = GlassPanelView(cornerRadius: 30)
    private let artworkView = ArtworkImageView()
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }

    private func setupView() {
        panelView.translatesAutoresizingMaskIntoConstraints = false
        artworkView.translatesAutoresizingMaskIntoConstraints = false
        artworkView.shape = .rounded(12)

        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        artistLabel.font = .systemFont(ofSize: 12, weight: .medium)
        artistLabel.textColor = UIColor.white.withAlphaComponent(0.50)
        artistLabel.numberOfLines = 1

        let textStack = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false

        let previousButton = IconButton(systemName: "backward.fill", pointSize: 18)
        let playButton = IconButton(systemName: "pause.fill", pointSize: 20)
        let nextButton = IconButton(systemName: "forward.fill", pointSize: 18)
        [previousButton, playButton, nextButton].forEach {
            $0.tintColor = .white
            $0.widthAnchor.constraint(equalToConstant: 38).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 38).isActive = true
        }
        previousButton.addTarget(self, action: #selector(didTapPrevious), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)

        let controlsStack = UIStackView(arrangedSubviews: [previousButton, playButton, nextButton])
        controlsStack.axis = .horizontal
        controlsStack.alignment = .center
        controlsStack.spacing = 4
        controlsStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(panelView)
        panelView.contentView.addSubview(artworkView)
        panelView.contentView.addSubview(textStack)
        panelView.contentView.addSubview(controlsStack)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            panelView.topAnchor.constraint(equalTo: topAnchor),
            panelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            panelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            panelView.bottomAnchor.constraint(equalTo: bottomAnchor),

            artworkView.leadingAnchor.constraint(equalTo: panelView.contentView.leadingAnchor, constant: 11),
            artworkView.centerYAnchor.constraint(equalTo: panelView.contentView.centerYAnchor),
            artworkView.widthAnchor.constraint(equalToConstant: 44),
            artworkView.heightAnchor.constraint(equalTo: artworkView.widthAnchor),

            textStack.leadingAnchor.constraint(equalTo: artworkView.trailingAnchor, constant: 12),
            textStack.centerYAnchor.constraint(equalTo: panelView.contentView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: controlsStack.leadingAnchor, constant: -10),

            controlsStack.trailingAnchor.constraint(equalTo: panelView.contentView.trailingAnchor, constant: -12),
            controlsStack.centerYAnchor.constraint(equalTo: panelView.contentView.centerYAnchor)
        ])
    }

    @objc private func didTapView() {
        onTap?()
    }

    @objc private func didTapPrevious() {
        onPrevious?()
    }

    @objc private func didTapNext() {
        onNext?()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var touchedView = touch.view
        while let view = touchedView {
            if view is UIControl {
                return false
            }
            touchedView = view.superview
        }
        return true
    }
}
