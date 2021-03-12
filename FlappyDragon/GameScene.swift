//
//  GameScene.swift
//  FlappyDragon
//
//  Created by Matheus Torres on 12/03/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var floor: SKSpriteNode!
    var intro: SKSpriteNode!
    
    private var gameArea: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        addBackground()
        addFloor()
        gameArea = size.height - floor.size.height
        addIntro()
        addPlayer()
        
    }
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2,
                                      y: size.height/2)
        background.zPosition = 0
        background.size = size
        addChild(background)
    }
    
    private func addFloor() {
        floor = SKSpriteNode(imageNamed: "floor")
        floor.zPosition = 2
        floor.position = CGPoint(x: floor.size.width/2,
                                 y: floor.size.height/2)
        addChild(floor)
    }
    
    private func addIntro() {
        intro = SKSpriteNode(imageNamed: "intro")
        intro.zPosition = 3
        intro.position = CGPoint(x: size.width/2,
                                 y: size.height/2)
        intro.size = CGSize(width: size.width * 0.75, height: size.height * 0.75)
        addChild(intro)
    }
    
    private func addPlayer() {
        player = SKSpriteNode(imageNamed: "player1")
        player.zPosition = 4
        player.position = CGPoint(x: 60,
                                  y: size.height - gameArea/2)
        player.size = CGSize(width: 80, height: 80)
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
