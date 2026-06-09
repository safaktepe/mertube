//
//  Song.swift
//  Mertube
//

import UIKit

struct Song: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let artist: String
    let duration: TimeInterval
    let artwork: Artwork

    static func == (lhs: Song, rhs: Song) -> Bool {
        lhs.id == rhs.id
    }
}

struct Playlist: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let songs: [Song]

    var artwork: Artwork {
        songs.first?.artwork ?? Artwork(colors: [.systemPurple, .systemBlue], symbolName: "music.note")
    }
}

struct Artwork {
    let colors: [UIColor]
    let symbolName: String

    static let bloom = Artwork(colors: [
        UIColor(red: 0.98, green: 0.68, blue: 0.78, alpha: 1),
        UIColor(red: 0.47, green: 0.47, blue: 0.96, alpha: 1),
        UIColor(red: 0.88, green: 0.72, blue: 1, alpha: 1)
    ], symbolName: "sparkles")

    static let pulse = Artwork(colors: [
        UIColor(red: 0.20, green: 0.90, blue: 0.88, alpha: 1),
        UIColor(red: 0.62, green: 0.32, blue: 0.95, alpha: 1),
        UIColor(red: 0.95, green: 0.38, blue: 0.54, alpha: 1)
    ], symbolName: "waveform")

    static let dusk = Artwork(colors: [
        UIColor(red: 0.18, green: 0.20, blue: 0.46, alpha: 1),
        UIColor(red: 0.88, green: 0.42, blue: 0.38, alpha: 1),
        UIColor(red: 0.96, green: 0.78, blue: 0.36, alpha: 1)
    ], symbolName: "sunset")

    static let velvet = Artwork(colors: [
        UIColor(red: 0.25, green: 0.07, blue: 0.22, alpha: 1),
        UIColor(red: 0.72, green: 0.32, blue: 0.82, alpha: 1),
        UIColor(red: 0.36, green: 0.60, blue: 1, alpha: 1)
    ], symbolName: "moon.stars")
}
