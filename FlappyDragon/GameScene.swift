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
    private let scoreSound = SKAction.playSoundFileNamed("score.mp3", waitForCompletion: false)
    private let gameOverSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    
    weak var gameViewController: GameViewController?
    
    private var player: SKSpriteNode!
    private var floor: SKSpriteNode!
    private var intro: SKSpriteNode!
    private var scoreLabel: SKLabelNode!
    
    private var timer: Timer!
    
    private var gameArea: CGFloat = 0.0
    private var velocity: Double = 100.0
    private var gameStarted = false
    private var gameFinished = false
    private var restart = false
    private var score: Int = 0 {
        didSet {
            guard score != oldValue else { return }
            scoreLabel.text = String(score)
        }
    }
    
    private var playerCategory: UInt32 = 1
    private var enemyCategory: UInt32 = 2
    private var scoreCategory: UInt32 = 4
    
    override func didMove(to view: SKView) {
        gameArea = size.height - floorHeight
        
        physicsWorld.contactDelegate = self
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
        
        let invisibleFloor = SKNode()
        invisibleFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        invisibleFloor.physicsBody?.isDynamic = false
        invisibleFloor.physicsBody?.categoryBitMask = enemyCategory
        invisibleFloor.physicsBody?.contactTestBitMask = playerCategory
        invisibleFloor.position = CGPoint(x: size.width/2, y: size.height - gameArea)
        invisibleFloor.zPosition = 2
        addChild(invisibleFloor)
        
        let invisibleRoof = SKNode()
        invisibleRoof.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        invisibleRoof.physicsBody?.isDynamic = false
        invisibleRoof.position = CGPoint(x: size.width/2, y: size.height)
        invisibleRoof.zPosition = 2
        addChild(invisibleRoof)
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
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: size.width/2,
                                      y: size.height - 150)
        scoreLabel.alpha = 0.8
        addChild(scoreLabel)
    }
    
    private func spawnEnemies() {
        let topSafeArea = (UIApplication.shared.windows.first?.safeAreaInsets.top)!
        let initialPosition = CGFloat(Int.random(in: Int(topSafeArea)..<Int(gameArea/2)))
        let enemyNumber = Int.random(in: 1...4)
        let enemiesDistance = player.size.width * 2.5
        
        let enemyTop = SKSpriteNode(imageNamed: "enemytop\(enemyNumber)")
        let enemyWidth = enemyTop.size.width
        let enemyHeight = enemyTop.size.height
        
        enemyTop.position = CGPoint(x: size.width + enemyWidth/2,
                                    y: size.height - initialPosition + enemyHeight/2)
        enemyTop.zPosition = 1
        enemyTop.size = CGSize(width: enemyWidth * 1.5, height: enemyHeight * 1.5)
        enemyTop.physicsBody = SKPhysicsBody(rectangleOf: enemyTop.size)
        enemyTop.physicsBody?.isDynamic = false
        enemyTop.physicsBody?.categoryBitMask = enemyCategory
        enemyTop.physicsBody?.contactTestBitMask = playerCategory
        
        let enemyBottom = SKSpriteNode(imageNamed: "enemybottom\(enemyNumber)")
        enemyBottom.position = CGPoint(x: size.width + enemyWidth/2,
                                       y: enemyTop.position.y - enemyTop.size.height - enemiesDistance)
        enemyBottom.zPosition = 1
        enemyBottom.size = CGSize(width: enemyWidth * 1.5, height: enemyHeight * 1.5)
        enemyBottom.physicsBody = SKPhysicsBody(rectangleOf: enemyBottom.size)
        enemyBottom.physicsBody?.isDynamic = false
        enemyBottom.physicsBody?.categoryBitMask = enemyCategory
        enemyBottom.physicsBody?.contactTestBitMask = playerCategory
        
        let laser = SKNode()
        laser.position = CGPoint(x: enemyTop.position.x + enemyWidth/2,
                                 y: enemyTop.position.y - enemyTop.size.height/2 - enemiesDistance/2)
        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: enemiesDistance))
        laser.physicsBody?.isDynamic = false
        laser.physicsBody?.categoryBitMask = scoreCategory
        
        let distance = size.width + enemyWidth * 1.5
        let duration = Double(distance)/velocity
        let moveAction = SKAction.moveBy(x: -distance, y: 0, duration: duration)
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveAction, removeAction])
        
        enemyBottom.run(sequenceAction)
        enemyTop.run(sequenceAction)
        laser.run(sequenceAction)
        
        addChild(enemyTop)
        addChild(enemyBottom)
        addChild(laser)
    }
    
    private func gameOver() {
        timer.invalidate()
        player.texture = SKTexture(imageNamed: "playerDead")
        for node in children {
            node.removeAllActions()
        }
        player.physicsBody?.isDynamic = false
        gameFinished = true
        gameStarted = false
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] timer in
            guard let self = self else { return }
            let gameOverLabel = SKLabelNode(fontNamed: "chalkduster")
            gameOverLabel.fontColor = .red
            gameOverLabel.fontSize = 50
            gameOverLabel.text = "Game Over"
            gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            gameOverLabel.zPosition = 5
            self.addChild(gameOverLabel)
            self.restart = true
        }
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
                player.physicsBody?.categoryBitMask = playerCategory
                player.physicsBody?.contactTestBitMask = scoreCategory
                player.physicsBody?.collisionBitMask = enemyCategory

                gameStarted = true
                
                timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { [weak self] timer in
                    guard let self = self else { return }
                    self.spawnEnemies()
                }
            } else {
                // Playing
                player.physicsBody?.velocity = CGVector.zero
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
            }
        } else {
          // Dead
            if restart {
                restart = false
                gameViewController?.presentScene()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameStarted {
            let yVelocity = (player.physicsBody?.velocity.dy)! * 0.001 as CGFloat
            player.zRotation = yVelocity
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if gameStarted {
            if contact.bodyA.categoryBitMask == scoreCategory || contact.bodyB.categoryBitMask == scoreCategory {
                score += 1
                run(scoreSound)
            }
            
            if contact.bodyA.categoryBitMask == enemyCategory || contact.bodyB.categoryBitMask == enemyCategory {
                gameOver()
                run(gameOverSound)
                gameViewController?.stopMusic()
            }
        }
    }
}
