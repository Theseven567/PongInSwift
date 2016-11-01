//
//  GameScene.swift
//  Pong
//
//  Created by Егор on 10/12/16.
//  Copyright © 2016 Егор. All rights reserved.
//

import SpriteKit
import GameplayKit

class Multiplayer: SKScene {
    var xvector:Double = 30
    var yvector:Double = 30
    var difficulty = 0.08
    var viewController = GameViewController()
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    var enemyScoreLabel = SKLabelNode()
    var mainScoreLabel = SKLabelNode()
    var enemyLabelPoint = CGPoint(x: 0, y: 320)
    var mainLabelPoint = CGPoint(x: 0, y: -320)
    var winLabel = SKSpriteNode(imageNamed: "WON!")
    var lostLabel = SKSpriteNode(imageNamed: "LOST")
    var buttonsSize = CGSize(width: 500, height: 200)
    var restartButton  = SKSpriteNode(imageNamed: "RESTART")
    var menuButton = SKSpriteNode(imageNamed: "MENU")
    var mainScore  = 0 { didSet { mainScoreLabel.text = "\(mainScore)" } }
    var enemyScore = 0 { didSet { enemyScoreLabel.text = "\(enemyScore)" } }
    
    enum Sides {
        case main
        case enemy
    }
    
    override func didMove(to view: SKView) {
        self.view?.isMultipleTouchEnabled = true
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball.physicsBody?.allowsRotation = true
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        main = self.childNode(withName: "main") as! SKSpriteNode
        ball.physicsBody?.applyImpulse(CGVector(dx: xvector, dy: yvector))
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1.0
        self.physicsBody = border
        // Score labels
        mainScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        enemyScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        mainScoreLabel.text = "0"
        enemyScoreLabel.text = "0"
        enemyScoreLabel.horizontalAlignmentMode = .right
        mainScoreLabel.horizontalAlignmentMode = .right
        mainScoreLabel.position = CGPoint(x: 320, y: -50)
        enemyScoreLabel.position = CGPoint(x: 320, y: 50)
        mainScoreLabel.fontSize = 105
        enemyScoreLabel.fontSize = 105
        addChild(mainScoreLabel)
        addChild(enemyScoreLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.isMultipleTouchEnabled = true

        for touch: UITouch in touches{
            let location = touch.location(in: self)
            if (location.y > 0){
                enemy.run(SKAction.moveTo(x: location.x, duration: 0.15))
            }else{
                main.run(SKAction.moveTo(x: location.x, duration: 0.15))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: UITouch in touches{
            let location = touch.location(in: self)
            if (location.y > 0){
                enemy.run(SKAction.moveTo(x: location.x, duration: 0.15))
            }else{
                main.run(SKAction.moveTo(x: location.x, duration: 0.15))
            }
        }
        
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if (restartButton.contains(location)){
                removeRestartButton()
                removeOutcomeLabels()
                removeMenuButton()
                resetGame(side: .enemy)
            }else if menuButton.contains(location){
                let menuScene = SKScene(fileNamed: "Menu")
                menuScene?.scaleMode = .aspectFill
                prepareForMenuJump()
                scene?.view?.presentScene(menuScene!, transition: SKTransition.doorsCloseVertical(withDuration: 4))
            }
        }
    }
    private func prepareForMenuJump(){
        mainScoreLabel.isHidden = true
        enemyScoreLabel.isHidden = true
        ball.isHidden = true
        main.isHidden = true
        scene?.view?.isPaused = false
    }
    private  func resetGame(side:Sides){
        scene?.view?.isPaused = false
        ball.position = CGPoint(x:0, y:0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        switch side {
        case .enemy:
            ball.physicsBody?.applyImpulse(CGVector(dx: xvector , dy: yvector * -1))
        case .main:
            ball.physicsBody?.applyImpulse(CGVector(dx: xvector * -1 , dy: yvector ))
        }
    }
    private func displayLabels(forWinner:Sides){
        switch forWinner {
        case .enemy :
            lostLabel.position = mainLabelPoint
            winLabel.position = enemyLabelPoint
            addChild(winLabel)
            addChild(lostLabel)
        case .main:
            winLabel.position = mainLabelPoint
            lostLabel.position = enemyLabelPoint
            addChild(winLabel)
            addChild(lostLabel)
        }
    }
    private func removeOutcomeLabels(){
        winLabel.removeFromParent()
        lostLabel.removeFromParent()
    }
    private func winEvent(side:Sides){
        scene?.view?.isPaused = true
        switch side {
        case .enemy:
            displayLabels(forWinner: .enemy)
        case .main:
            displayLabels(forWinner: .main)
        }
        addRestartButton()
        addMenuButton()
    }
    private func addRestartButton(){
        restartButton.size = buttonsSize
        restartButton.position = CGPoint(x: 0, y: 150)
        restartButton.zPosition = 1
        addChild(restartButton)
    }
    private func addMenuButton(){
        menuButton.size = buttonsSize
        menuButton.position = CGPoint(x: 0, y: -150)
        menuButton.zPosition = 1
        addChild(menuButton)
    }
    private func removeRestartButton(){
        restartButton.removeFromParent()
    }
    private func removeMenuButton(){
        menuButton.removeFromParent()
    }
    override func update(_ currentTime: TimeInterval) {
        //             Called before each frame is rendered
        if ball.position.y < main.position.y - 60 {
            resetGame(side: Sides.main)
            enemyScore += 1
        }else if ball.position.y > enemy.position.y + 60{
            resetGame(side: Sides.enemy)
            mainScore += 1
        }
        if (mainScore == 5){
            mainScore = 0
            enemyScore =  0
            winEvent(side: .main)
        }else if enemyScore == 5{
            mainScore = 0
            enemyScore = 0
            winEvent(side: .enemy)
        }
    }
}

