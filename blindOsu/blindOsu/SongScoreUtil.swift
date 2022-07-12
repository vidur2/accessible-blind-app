//
//  SongScoreUtil.swift
//  blindOsu
//
//  Created by Vidur Modgil on 7/11/22.
//

import Foundation
import UIKit


class SongScoreUtil {
    var score = 0;
    var controller: UIViewController;
    var screenWidth: Double;
    var screenHeight: Double;
    var radius: Double;
    var time: Double;
    
    init(controller: UIViewController, radius: Double, time: Double) {
        self.controller = controller
        
        // Getting screen variables
        let screenRect = UIScreen.main.bounds;
        self.screenWidth = screenRect.size.width;
        self.screenHeight = screenRect.size.height;
        self.time = time;
        self.radius = radius;
    }
    
    func scoreSong(gameData: [RelativeModelCoord], touches: Set<UITouch>) {
        while player!.isPlaying {
            var prevCoord: Double = 0.0
            for coord in gameData {
                if player!.currentTime <= coord.time && player!.currentTime > prevCoord {
                    if self.checkIfValidTouch(coord: coord, touches: touches) {
                        self.score += 1;
                        Thread.sleep(forTimeInterval: 1)
                    }
                }
                prevCoord = coord.time
            }
        }
    }
    
    private func checkIfValidTouch(coord: RelativeModelCoord, touches: Set<UITouch>) -> Bool {
        let scaledX = coord.relative_pitch_x * screenWidth;
        let scaledY = coord.relative_pitch_y * screenHeight;
        
        for touch in touches {
            let location = touch.location(in: self.controller.view);
            let scaledTouchX = location.x - (self.screenWidth/2)
            let scaledTouchY = location.y - (self.screenHeight/2)
            let valid: Bool = abs(scaledX - scaledTouchX) < self.radius && abs(scaledY - scaledTouchY) < self.radius;
            if valid {
                return true
            }
        }
        
        return false;
    }
}
