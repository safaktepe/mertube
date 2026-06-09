//
//  PlaylistDetailViewModel.swift
//  Mertube
//

import Foundation

final class PlaylistDetailViewModel {
    let playlist: Playlist

    init(playlist: Playlist) {
        self.playlist = playlist
    }

    var title: String {
        playlist.title
    }

    var songs: [Song] {
        playlist.songs
    }
}
