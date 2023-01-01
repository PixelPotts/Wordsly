//
//  GameViewController.swift
//  test iOS
//
//  Created by Bryan Potts on 12/31/22.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    var gameController: GameController!
    var gameView: SCNView { return self.view as! SCNView}
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Check if a swipe up or down has occurred
        if let touch = touches.first {
            if touch.location(in: self.view).y != touch.previousLocation(in: self.view).y {
                if(!gameController.swipeAnimationPlaying) {
                    // Swipe up occurred
                    //                print("Debug message: User swiped up on cube")
                    gameController.handleSwipe(
                        direction:
                            touch.location(in: self.view).y
                                <= touch.previousLocation(in: self.view).y ? "down" : "up",
                        location: (x: Float(touch.location(in: self.view).x), y: Float(touch.location(in: self.view).y))
                    )
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameController = GameController(sceneRenderer: gameView)
    }
    
    
    
    
    
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
