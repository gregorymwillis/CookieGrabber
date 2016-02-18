//
//  TitleScene.swift
//  Cookie Grabber
//
//  Created by Greg Willis on 2/16/16.
//  Copyright © 2016 Willis Programming. All rights reserved.
//

import Foundation
import SpriteKit

class TitleScene : SKScene {

    var playButton = UIButton()
    var gameTitle = SKLabelNode?()
    var hudTextColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        setUpText()
    }
    
    func setUpText() {
        gameTitle = SKLabelNode(fontNamed: "Courier")
        gameTitle?.fontSize = 50
        gameTitle?.fontColor = hudTextColor
        gameTitle?.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        gameTitle?.text = "Cookie Grabber"
        self.addChild(gameTitle!)
        
        playButton = UIButton(frame: CGRect(x: 100, y: 100, width: 500, height: 100))
        playButton.center = CGPoint(x: (view?.frame.size.width)! / 2, y: (view?.frame.size.height)! * 0.85)
        playButton.titleLabel?.font = UIFont(name: "Courier", size: 50)
        playButton.setTitle("Play", forState: UIControlState.Normal)
        playButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        playButton.addTarget(self, action: Selector("playTheGame"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(playButton)
    }
    
    func playTheGame() {
        self.view?.presentScene(GameScene(), transition: SKTransition.fadeWithDuration(1.0))
        gameTitle?.removeFromParent()
        playButton.removeFromSuperview()
        
        if let scene = GameScene(fileNamed: "GameScene") {
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
    
}
