//
//  PlaylistDetailViewController.swift
//  Mertube
//

import UIKit

final class PlaylistDetailViewController: UIViewController {
    var onSongSelected: (([Song], Song) -> Void)?

    private let viewModel: PlaylistDetailViewModel
    private let tableView = UITableView(frame: .zero, style: .plain)

    init(viewModel: PlaylistDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 170, right: 0)
        tableView.rowHeight = 92
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SongCell.self, forCellReuseIdentifier: SongCell.reuseIdentifier)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PlaylistDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongCell.reuseIdentifier, for: indexPath) as? SongCell
        cell?.configure(with: viewModel.songs[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = viewModel.songs[indexPath.row]
        onSongSelected?(viewModel.songs, song)
    }
}
