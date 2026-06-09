//
//  TimeInterval+Formatting.swift
//  Mertube
//

import Foundation

extension TimeInterval {
    var mertubeDurationText: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
