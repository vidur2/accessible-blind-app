

//
//  StateManager.swift
//  Personalized Eco Routing
//
//  Created by Vidur Modgil on 6/1/22.
//
import Foundation
import UIKit

enum State {
    case gameView
    case initView
}

class StateManager {
    
    let viewController: UIViewController
    
    private var currentState: State;

    
    private let containedViewControllers: [State: UIViewController] = [
      .gameView: GameViewController(),
      .initView: ViewController()
    ]
    
    func transition(to state: State) {
      // Remove current vc
      let currentVc = containedViewControllers[currentState]
      if currentVc?.parent != nil {
        currentVc?.willMove(toParent: nil)
        currentVc?.view.removeFromSuperview()
        currentVc?.removeFromParent()
      }

        // Add new vc
        guard let newVc = containedViewControllers[state] else { return }
        self.currentState = state
        self.viewController.addChild(newVc)
        self.viewController.view.addSubview(newVc.view)
        newVc.didMove(toParent: self.viewController)
    }
    
    init(viewController: UIViewController, initState: State) {
        self.viewController = viewController
        self.currentState = initState
    }
}
