//
//  ConfigState.swift
//  blindOsu
//
//  Created by Vidur Modgil on 7/12/22.
//

import Foundation


class ConfigState {
    private var songChoice: String?;
    static let shared = ConfigState()
    
    func setSong(song: String) {
        if song.starts(with: "https://") {
            let videoId = song.split(separator: "=")[1]
            self.songChoice = String(videoId)
        } else {
            self.songChoice = song
        }
    }
    
    func getSong() -> String? {
        return self.songChoice;
    }
}
