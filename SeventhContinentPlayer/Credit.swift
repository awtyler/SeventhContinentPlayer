//
//  Credit.swift
//  SeventhContinentPlayer
//
//  Created by Aaron Tyler on 2/4/19.
//  Copyright © 2019 Aaron Tyler. All rights reserved.
//

import Foundation

class Credit {
    
    let trackNumber: Int
    let trackName: String
    let soundName: String
    let artist: String?
    
    init(trackNumber: Int, trackName: String, soundName: String, artist: String? = nil) {
        self.trackNumber = trackNumber
        self.trackName = trackName
        self.soundName = soundName
        self.artist = artist
    }
    
}
