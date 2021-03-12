//
//  GameScene.swift
//  FlappyDragon
//
//  Created by Matheus Torres on 12/03/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let floorHeight: CGFloat = 200
    private let flyForce: CGFloat = 50.0
    
    private var player: SKSpriteNode!
    private var floor: SKSpriteNode!
    private var intro: SKSpriteNode!
    private var scoreLabel: SKLabelNode!
    
    private var gameArea: CGFloat = 0.0
    private var velocity: Double = 100.0
    private var gameStarted = false
    private var gameFinished = false
    private var restart = false
    private var score: Int = 0
    
    override func didMove(to view: SKView) {
        gameArea = size.height - floorHeight
        addBackground()
        addFloor()
        addIntro()
        addPlayer()
        moveFloor()
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
        floor.position = CGPoint(x: floor.size.width/1.5,
                                 y: floor.size.height/2)
        floor.size = CGSize(width: size.width*2, height: 200)
        addChild(floor)
    }
    
    private func addIntro() {
        intro = SKSpriteNode(imageNamed: "intro")
        intro.zPosition = 3
        intro.position = CGPoint(x: size.width/2,
                                 y: size.height - gameArea/2)
        intro.size = CGSize(width: size.width * 0.75, height: size.height * 0.75)
        addChild(intro)
    }
    
    private func addPlayer() {
        player = SKSpriteNode(imageNamed: "player1")
        player.zPosition = 4
        player.position = CGPoint(x: 60,
                                  y: size.height - gameArea/2)
        player.size = CGSize(width: 80, height: 80)
        
        var playerTextures = [SKTexture]()
        for i in 1...4 {
            playerTextures.append(SKTexture(imageNamed: "player\(i)"))
        }
        
        let animationAction = SKAction.animate(with: playerTextures, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatForever(animationAction)
        
        player.run(repeatAction)
        
        addChild(player)
    }
    
    private func moveFloor() {
        let duration = Double(floor.size.width/2)/velocity
        
        let moveFloorAction = SKAction.moveBy(x: -floor.size.width/2, y: 0, duration: duration)
        let resetXAction = SKAction.moveBy(x: floor.size.width/2, y: 0, duration: 0)
        
        let sequenceAction = SKAction.sequence([moveFloorAction, resetXAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        floor.run(repeatAction)
    }
    
    private func addScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 100
        scoreLabel.text = String(score)
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: size.width/2,
                                      y: size.height - 150)
        scoreLabel.alpha = 0.8
        addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameFinished {
            if !gameStarted {
                // Menu
                intro.removeFromParent()
                addScore()
                
                player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2 - 10)
                player.physicsBody?.isDynamic = true
                player.physicsBody?.allowsRotation = true
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
                
                gameStarted = true
            } else {
                // Playing
                player.physicsBody?.velocity = CGVector.zero
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
            }
        } else {
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameStarted {
            let yVelocity = (player.physicsBody?.velocity.dy)! * 0.001 as CGFloat
            player.zRotation = yVelocity
        }
    }
}
