//
//  HomeViewController.swift
//  Mertube
//

import UIKit

final class HomeViewController: UINavigationController {
    var onPlaylistSelected: ((Playlist) -> Void)? {
        didSet {
            rootController.onPlaylistSelected = onPlaylistSelected
        }
    }

    var onSongSelected: (([Song], Song) -> Void)? {
        didSet {
            rootController.onSongSelected = onSongSelected
        }
    }

    private let rootController: PlaylistListViewController

    init(viewModel: LibraryViewModel) {
        rootController = PlaylistListViewController(viewModel: viewModel)
        super.init(rootViewController: rootController)
        setupNavigationBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNavigationBar() {
        navigationBar.prefersLargeTitles = true
        navigationBar.tintColor = .white
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        view.backgroundColor = .clear
    }
}
