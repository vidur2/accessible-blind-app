//
//  GameViewController.swift
//  blindOsu
//
//  Created by Vidur Modgil on 7/12/22.
//

import Foundation
import UIKit


class GameViewController: UIViewController {
    
    var res: VideoResYin?;
    var score: Int?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.score = 0;
    
        do {
            // Do any additional setup after loading the view.
            self.res = YoutubeMp3.shared.getVideoYin()
            
            try YoutubeMp3.shared.playSong(dataUrl: self.res!.base64_url)
            print("Playing")
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch registered")
        let score = SongScoreUtil(controller: self, radius: 0.1, time: 1);
        if player!.isPlaying {
            score.scoreSongYin(gameData: self.res!.pitch_coordinate, touches: touches)
        } else {
            let stateManager = StateManager(viewController: self, initState: .gameView)
            stateManager.transition(to: .initView)
        }
        print(self.score)
        self.score! += score.score
    }
}
