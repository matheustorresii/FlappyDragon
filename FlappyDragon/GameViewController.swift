//
//  GameViewController.swift
//  FlappyDragon
//
//  Created by Matheus Torres on 12/03/21.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    var stage: SKView!
    var musicPlayer: AVAudioPlayer!
    
    override var prefersStatusBarHidden: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        stage = view as? SKView
        stage.ignoresSiblingOrder = true
        
        presentScene()
    }
    
    private func playMusic() {
        if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a") {
            musicPlayer = try! AVAudioPlayer(contentsOf: musicURL)
            musicPlayer.numberOfLoops = -1
            musicPlayer.volume = 0.4
            musicPlayer.play()
        }
    }
    
    func stopMusic() {
        musicPlayer.stop()
    }
    
    func presentScene() {
        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        scene.gameViewController = self
        stage.presentScene(scene, transition: .crossFade(withDuration: 0.5))
        playMusic()
    }
}
