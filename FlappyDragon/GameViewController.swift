//
//  GameViewController.swift
//  FlappyDragon
//
//  Created by Matheus Torres on 12/03/21.
//

import UIKit
import SpriteKit
import GameplayKit

var stage: SKView!

class GameViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        stage = view as? SKView
        stage.ignoresSiblingOrder = true
        
        presentScene()
    }
    
    private func presentScene() {
        let bounds = UIScreen.main.bounds.size
        let scene = GameScene(size: CGSize(width: bounds.width, height: bounds.height))
        scene.scaleMode = .aspectFill
        stage.presentScene(scene)
        
    }

}
