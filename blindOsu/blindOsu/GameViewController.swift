//
//  GameViewController.swift
//  blindOsu
//
//  Created by Vidur Modgil on 7/12/22.
//

import Foundation
import UIKit


class GameViewController: UIViewController {
    
    var res: VideoRes?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        do {
            // Do any additional setup after loading the view.
            self.res = YoutubeMp3.shared.getVideoAsMp3()
            
            try YoutubeMp3.shared.playSong(dataUrl: self.res!)
            print("Playing")
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let score = SongScoreUtil(controller: self, radius: 0.1, time: 1);
        if player!.isPlaying {
            score.scoreSong(gameData: self.res!.model_coord, touches: touches)
        }
    }
}
