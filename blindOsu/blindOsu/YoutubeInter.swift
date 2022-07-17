//
//  YoutubeInter.swift
//  blindOsu
//
//  Created by Vidur Modgil on 6/28/22.
//

import Foundation
import AVFAudio
import UIKit
var player: AVAudioPlayer?


struct VideoRes: Decodable {
    let base64_url: String,
        model_coord: [RelativeModelCoord]
}

struct RelativeModelCoord: Decodable {
    let relative_pitch_x: Double,
        relative_pitch_y: Double,
        time: Double
}


class YoutubeMp3 {
    let backendUri = "http://localhost:5001"
    private var res: Data? = nil;
    
    static let shared = YoutubeMp3()
    
    func getVideoAsMp3() -> VideoRes {
        
        let videoId = ConfigState.shared.getSong();
        
        let parameters: [String: String?] = [
            "video_id": videoId,
        ]
        
        let res = self.sendRequest(path: "/get_video", params: parameters)
        
        if res != nil {
            let userDataRes = try! JSONDecoder().decode(VideoRes.self, from: res!)
            
            return userDataRes
        } else {
            return self.getVideoAsMp3()
        }
    }
    
    func playSong(dataUrl: VideoRes) throws {
        let data = Data(base64Encoded: dataUrl.base64_url)
        
        if let dataUw = data {
            do {
                try self.playSound(audioData: dataUw)
            } catch {
                throw error
            }
        }
    }
    
    static func testSoundPlay() {
        let backend = YoutubeMp3()
        ConfigState.shared.setSong(song: "https://www.youtube.com/watch?v=f5lZXCnh5So")
        let data = backend.getVideoAsMp3()
        
        do {
            try backend.playSong(dataUrl: data)
            print("Playing")
        } catch {
            print(error.localizedDescription)
        }
    }
    
   private func playSound(audioData: Data) throws {

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(data: audioData, fileTypeHint: "audio.mp3")

            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
            print("Playing")
        } catch let error {
            throw error
        }
    }
    
    private func sendRequest(path: String, params: [String: Any]) -> Data? {
        self.res = nil
        
        let url = URL(string: self.backendUri + path)
        
        let valid = _sendRequest(url: url, params: params)
        
        if valid && self.res != nil {
            return self.res
        } else {
            return nil
        }
    }
        
    private func _sendRequest(url: URL?, params: [String: Any]) -> Bool {
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        do {
            let decoded = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = decoded
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    self.res = data!
                }
            })
            
            task.resume()
            while !task.progress.isFinished { print("In progress...") }
            
            return true
            
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
}
