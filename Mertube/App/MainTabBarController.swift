//
//  MainTabBarController.swift
//  Mertube
//

import UIKit

final class MainTabBarController: UIViewController {
    private let libraryViewModel = LibraryViewModel()
    private let contentContainer = UIView()
    private let glassTabBar = GlassTabBar()

    private lazy var homeController = HomeViewController(viewModel: libraryViewModel)
    private lazy var nowPlayingController = NowPlayingPlaceholderViewController()
    private lazy var settingsController = SettingsViewController()
    private var currentController: UIViewController?

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

        view.addSubview(backgroundView)
        view.addSubview(contentContainer)
        view.addSubview(glassTabBar)

        glassTabBar.onSelect = { [weak self] index in
            self?.showPage(at: index)
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
            glassTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
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
        glassTabBar.configureArtwork(selectedSong.artwork)
        let playerController = PlayerViewController(viewModel: viewModel)
        playerController.onSongChanged = { [weak self] song in
            self?.glassTabBar.configureArtwork(song.artwork)
        }
        playerController.modalPresentationStyle = .fullScreen
        playerController.modalTransitionStyle = .coverVertical

        present(playerController, animated: true)
    }
}
