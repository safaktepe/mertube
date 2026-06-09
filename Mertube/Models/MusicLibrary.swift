//
//  MusicLibrary.swift
//  Mertube
//

import Foundation

protocol MusicLibraryProviding {
    var playlists: [Playlist] { get }
}

final class MusicLibrary: MusicLibraryProviding {
    let playlists: [Playlist]

    init() {
        let nightDrive = [
            Song(title: "Skin", artist: "Flume", duration: 176, artwork: .bloom),
            Song(title: "Glass Lights", artist: "Mira Vale", duration: 202, artwork: .pulse),
            Song(title: "Afterimage", artist: "Noon Circuit", duration: 194, artwork: .dusk)
        ]

        let softFocus = [
            Song(title: "Lavender Room", artist: "Arden", duration: 215, artwork: .velvet),
            Song(title: "Blue Petals", artist: "Yuna Park", duration: 188, artwork: .bloom),
            Song(title: "Mirror Tide", artist: "Eastline", duration: 231, artwork: .pulse)
        ]

        let lateSet = [
            Song(title: "Neon Bloom", artist: "Orion Bay", duration: 167, artwork: .pulse),
            Song(title: "Warm Static", artist: "Kaito", duration: 209, artwork: .dusk),
            Song(title: "Low Orbit", artist: "Vesper", duration: 196, artwork: .velvet)
        ]

        playlists = [
            Playlist(title: "Night Drive", subtitle: "\(nightDrive.count) songs", songs: nightDrive),
            Playlist(title: "Soft Focus", subtitle: "\(softFocus.count) songs", songs: softFocus),
            Playlist(title: "Late Set", subtitle: "\(lateSet.count) songs", songs: lateSet)
        ]
    }
}
