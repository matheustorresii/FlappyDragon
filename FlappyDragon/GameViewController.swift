//
//  GameViewController.swift
//  FlappyDragon
//
//  Created by Matheus Torres on 12/03/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let stage = self.view as! SKView? {
            view.layoutSubviews()
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            
            stage.ignoresSiblingOrder = true
            
            stage.presentScene(scene)
        }
    }
}
