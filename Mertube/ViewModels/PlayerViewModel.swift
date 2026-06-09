//
//  PlayerViewModel.swift
//  Mertube
//

import Foundation

final class PlayerViewModel {
    private(set) var songs: [Song]
    private(set) var currentIndex: Int {
        didSet {
            onChange?()
        }
    }

    var onChange: (() -> Void)?

    init(songs: [Song], selectedSong: Song) {
        self.songs = songs
        currentIndex = songs.firstIndex(of: selectedSong) ?? 0
    }

    var currentSong: Song {
        songs[currentIndex]
    }

    var previousSong: Song {
        songs[wrappedIndex(currentIndex - 1)]
    }

    var nextSong: Song {
        songs[wrappedIndex(currentIndex + 1)]
    }

    var durationText: String {
        currentSong.duration.mertubeDurationText
    }

    func playPrevious() {
        currentIndex = wrappedIndex(currentIndex - 1)
    }

    func playNext() {
        currentIndex = wrappedIndex(currentIndex + 1)
    }

    private func wrappedIndex(_ index: Int) -> Int {
        guard !songs.isEmpty else { return 0 }
        return (index + songs.count) % songs.count
    }
}
