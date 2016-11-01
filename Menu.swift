//
//  Menu.swift
//  Pong
//
//  Created by Егор on 10/14/16.
//  Copyright © 2016 Егор. All rights reserved.
//

import SpriteKit
import GameplayKit

class Menu: SKScene {
    
    var backgroundImage = SKSpriteNode(imageNamed: "Background")
    var easyButton = SKSpriteNode()
    var normalButton = SKSpriteNode()
    var hardButton = SKSpriteNode()
    var multiplayerButton = SKSpriteNode()
    enum Difficulty {
        case easy
        case normal
        case hard
        case multiplayer
    }
    
    override func didMove(to view: SKView) {
        //Setting background
        backgroundImage.position = CGPoint(x: 0, y: 0)
        backgroundImage.size = self.size
        addChild(backgroundImage)
        // Setting buttons
        easyButton = self.childNode(withName: "easyButton") as! SKSpriteNode
        normalButton = self.childNode(withName: "normalButton") as! SKSpriteNode
        hardButton = self.childNode(withName: "hardButton") as! SKSpriteNode
        multiplayerButton = self.childNode(withName: "multiplayerButton") as! SKSpriteNode
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if (easyButton.contains(location)){
                loadScreenWith(difficulty: .easy)
            }else if normalButton.contains(location){
                loadScreenWith(difficulty: .normal)
            }else if hardButton.contains(location){
                loadScreenWith(difficulty: .hard)
            }else if multiplayerButton.contains(location){
                loadScreenWith(difficulty: .multiplayer)
            }
        }
    }
//    scene.scaleMode = .aspectFill
    private func loadScreenWith(difficulty: Difficulty){
        switch difficulty {
        case .easy:
        let easyScene = SKScene(fileNamed: "EasyMode")
            easyScene?.scaleMode = .aspectFill
            self.scene?.view?.presentScene(easyScene!, transition: SKTransition.doorsOpenVertical(withDuration: 2))
        case .normal:
            let normalScene = SKScene(fileNamed: "NormalMode")
            normalScene?.scaleMode = .aspectFill
                   self.scene?.view?.presentScene(normalScene!, transition: SKTransition.doorsOpenVertical(withDuration: 2))
        case .hard :
            let hardScene = SKScene(fileNamed: "HardMode")
            hardScene?.scaleMode = .aspectFill
            self.scene?.view?.presentScene(hardScene!, transition: SKTransition.doorsOpenVertical(withDuration: 2))
        case .multiplayer :
            let multiplayerScene = SKScene(fileNamed: "Multiplayer")
            multiplayerScene?.scaleMode = .aspectFill
            self.scene?.view?.presentScene(multiplayerScene!, transition: SKTransition.doorsOpenVertical(withDuration: 2))
        }
    }
}
