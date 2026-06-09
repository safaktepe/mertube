//
//  LibraryViewModel.swift
//  Mertube
//

import Foundation

final class LibraryViewModel {
    private let library: MusicLibraryProviding

    init(library: MusicLibraryProviding = MusicLibrary()) {
        self.library = library
    }

    var playlists: [Playlist] {
        library.playlists
    }
}
