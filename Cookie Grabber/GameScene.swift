//
//  GameScene.swift
//  Cookie Grabber
//
//  Created by Greg Willis on 2/10/16.
//  Copyright (c) 2016 Willis Programming. All rights reserved.
//

import SpriteKit

var player = SKSpriteNode?()
var squareCollect = SKSpriteNode?()
var circleAvoid = SKSpriteNode?()
var stars = SKSpriteNode?()

var scoreLabel = SKLabelNode?()
var mainLabel = SKLabelNode?()

var cookieSpeed = 4.0
var circleSpeed = 3.5

var isAlive = true

var hudColor = UIColor.whiteColor()

var score = 0

struct physicsCategory {
    static let player : UInt32 = 1
    static let squareCollect : UInt32 = 2
    static let circleAvoid : UInt32 = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        self.backgroundColor = UIColor.blackColor()
        
        spawnPlayer()
        spawnSquareCollect()
        spawnCircleAvoid()
        spawnStars()
        squareSpawnTimer()
        circleSpawnTimer()
        starsSpawnTimer()
        spawnScoreLabel()
        spawnMainLabel()
        hideMainLabel()
        resetVariablesOnStart()
    }
    
    func resetVariablesOnStart() {
        isAlive = true
        score = 0
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if isAlive == true {
                player?.position.x = location.x
                scoreLabel?.position.x = location.x
            }
            if isAlive == false {
                player?.position.x = -200
                mainLabel?.position = CGPoint(x: CGRectGetMidX(self.frame), y: (mainLabel?.position.y)!)

            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if isAlive == false {
            player?.position.x = -200
            mainLabel?.position = CGPoint(x: CGRectGetMidX(self.frame), y: (mainLabel?.position.y)!)
        }
    }
    
    func spawnPlayer() {
        player = SKSpriteNode(imageNamed: "robotHand")
        player?.size = CGSize(width: 50, height: 50)
        player?.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.size.height * 0.15)
        player?.physicsBody = SKPhysicsBody(rectangleOfSize: player!.size)
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody?.categoryBitMask = physicsCategory.player
        player?.physicsBody?.contactTestBitMask = physicsCategory.squareCollect
        player?.physicsBody?.dynamic = false
        
        self.addChild(player!)
    }
    
    func spawnSquareCollect() {
        squareCollect = SKSpriteNode(imageNamed: "cookie")
        squareCollect?.size = CGSize(width: 40, height: 40)
        squareCollect?.position = CGPoint(x: Int(arc4random_uniform(700) + 300), y: 800)
        let moveForward = SKAction.moveToY(-100, duration: cookieSpeed)
        let destroy = SKAction.removeFromParent()
        
        squareCollect?.physicsBody = SKPhysicsBody(rectangleOfSize: squareCollect!.size)
        squareCollect?.physicsBody?.affectedByGravity = false
        squareCollect?.physicsBody
        squareCollect?.physicsBody?.categoryBitMask = physicsCategory.squareCollect
        squareCollect?.physicsBody?.dynamic = true
        
        squareCollect?.runAction(SKAction.sequence([moveForward, destroy]))
        
        self.addChild(squareCollect!)
    }
    
    func spawnCircleAvoid() {
        circleAvoid = SKSpriteNode(imageNamed: "monster")
        circleAvoid?.position = CGPoint(x: Int(arc4random_uniform(700) + 300), y: 800)
        circleAvoid?.size = CGSize(width: 40, height: 50)
        circleAvoid?.physicsBody = SKPhysicsBody(rectangleOfSize: (circleAvoid?.size)!)
        circleAvoid?.physicsBody?.affectedByGravity = false
        circleAvoid?.physicsBody?.allowsRotation = false
        circleAvoid?.physicsBody?.categoryBitMask = physicsCategory.circleAvoid
        circleAvoid?.physicsBody?.dynamic = true
        
        let moveForward = SKAction.moveToY(-100, duration: circleSpeed)
        let destroy = SKAction.removeFromParent()
        
        circleAvoid?.runAction(SKAction.sequence([moveForward, destroy]))

        self.addChild(circleAvoid!)
    }
    
    func spawnStars() {
        let randomSize = Int(arc4random_uniform(3) + 1)
        let randomSpeed = Double(arc4random_uniform(4) + 1)
        
        stars = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: randomSize, height: randomSize))
        stars?.position = CGPoint(x: Int(arc4random_uniform(700) + 300), y: 800)
        stars?.zPosition = -1
        
        let moveForward = SKAction.moveToY(-100, duration: randomSpeed)
        let destroy = SKAction.removeFromParent()
        
        stars?.runAction(SKAction.sequence([moveForward, destroy]))

        
        self.addChild(stars!)
    }
    
    func squareSpawnTimer() {
        let cookieTimer = SKAction.waitForDuration(1.0)
        let spawn = SKAction.runBlock {
            self.spawnSquareCollect()
        }
        
        let sequence = SKAction.sequence([cookieTimer, spawn])
        self.runAction(SKAction.repeatActionForever(sequence))

    }
    
    func circleSpawnTimer() {
        let circleTimer = SKAction.waitForDuration(0.5)
        let spawn = SKAction.runBlock {
            self.spawnCircleAvoid()
        }
        
        let sequence = SKAction.sequence([circleTimer, spawn])
        self.runAction(SKAction.repeatActionForever(sequence))
        
    }
    
    func starsSpawnTimer() {
        let starsTimer = SKAction.waitForDuration(0.05)
        let spawn = SKAction.runBlock {
            self.spawnStars()
        }
        
        let sequence = SKAction.sequence([starsTimer, spawn])
        self.runAction(SKAction.repeatActionForever(sequence))
        
    }
    
    func spawnScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Courier")
        scoreLabel?.fontSize = 50
        scoreLabel?.fontColor = hudColor
        scoreLabel?.position = CGPoint(x: (player?.position.x)!, y: (player?.position.y)!
         - 80)
        scoreLabel?.text = "\(score)"
        self.addChild(scoreLabel!)
    }
    
    func spawnMainLabel() {
        mainLabel = SKLabelNode(fontNamed: "Courier")
        mainLabel?.fontSize = 50
        mainLabel?.fontColor = hudColor
        mainLabel?.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        mainLabel?.text = "Start"
        self.addChild(mainLabel!)
    }
    
    func hideMainLabel() {
        let wait = SKAction.waitForDuration(2.0)
        let fadeOut = SKAction.fadeOutWithDuration(1.0)
        
        mainLabel!.runAction(SKAction.sequence([wait, fadeOut]))
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB
        
        if ((firstBody.categoryBitMask == physicsCategory.player) && (secondBody.categoryBitMask == physicsCategory.squareCollect) || (firstBody.categoryBitMask == physicsCategory.squareCollect) && (secondBody.categoryBitMask == physicsCategory.player)) {
            
//            spawnExplosion(firstBody.node as! SKSpriteNode)
            playerSquareCollision(firstBody.node as! SKSpriteNode, squareTemp: secondBody.node as! SKSpriteNode)
        }
        if ((firstBody.categoryBitMask == physicsCategory.player) && (secondBody.categoryBitMask == physicsCategory.circleAvoid) || (firstBody.categoryBitMask == physicsCategory.circleAvoid) && (secondBody.categoryBitMask == physicsCategory.player)) {
           
            playerCircleCollision(firstBody.node as! SKSpriteNode, circleTemp: secondBody.node as! SKSpriteNode)
        }
    }
    
    func playerSquareCollision(playerTemp: SKSpriteNode, squareTemp: SKSpriteNode) {
        squareTemp.removeFromParent()
        score += 1
        updateScore()
    }
    
    func playerCircleCollision(playerTemp: SKSpriteNode, circleTemp: SKSpriteNode) {
        mainLabel?.fontSize = 50
        mainLabel?.alpha = 1.0
        mainLabel?.text = "Game Over"
        isAlive = false
        waitThenMoveToTitleScene()
    }
    
    func updateScore() {
        scoreLabel?.text = "\(score)"
    }
    
    func waitThenMoveToTitleScene() {
        let wait = SKAction.waitForDuration(1.0)
        let transition = SKAction.runBlock {
            if let scene = TitleScene(fileNamed: "TitleScene") {
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
            }
    }
        let sequence = SKAction.sequence([wait, transition])
        self.runAction(SKAction.repeatAction(sequence, count: 1))
    }
    
    func spawnExplosion(squareTemp: SKSpriteNode) {
        let explosionEmitterPath : NSString = NSBundle.mainBundle().pathForResource("particleExplosion", ofType: "sks")!
        let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionEmitterPath as String) as! SKEmitterNode
        explosion.position = CGPoint(x: (squareTemp.position.x), y: (squareTemp.position.y))
        explosion.zPosition = 1
        explosion.targetNode = self
        self.addChild(explosion)
        let explosionTimer = SKAction.waitForDuration(1.0)
        let removeExplosion = SKAction.runBlock {
            explosion.removeFromParent()
        }
        self.runAction(SKAction.sequence([explosionTimer, removeExplosion]))
    }
}
