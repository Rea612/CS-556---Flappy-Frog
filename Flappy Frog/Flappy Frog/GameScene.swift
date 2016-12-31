//
//  GameScene.swift
//  Flappy Frog
//
//  Created by Mnady Zhao on 12/1/16.
//  Copyright © 2016 MnadyZhao. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let TYPE_FROG = UInt32(0x01);
    let TYPE_LAND = UInt32(0x01 << 1);
    let TYPE_APPLE = UInt32(0x01 << 2);
    let TYPE_PIPE = UInt32(0x01 << 3);
    
    var land = SKSpriteNode()
    var frog = SKSpriteNode()
    
    var sun = SKSpriteNode()
    
    var pipes = SKNode()
    
    var handlePipes = SKAction()
    
    var gameStarted = Bool()
    
    var score = Int()
    let scoreLbl = SKLabelNode()
    
    var died = Bool()
    var restartBtn = SKSpriteNode()
    var angelBtn = SKSpriteNode()
    
    var practiceMode = false
    
    func restartScene(){
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
        
    }
    
    func createScene(){
        
//        for family: String in UIFont.familyNames
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
        
        self.physicsWorld.contactDelegate = self
        var shortLen = min(self.frame.width, self.frame.height)
        
        practiceMode = false
        createAngelBtn()
        
        let bkgndNames = ["bkgnd1", "bkgnd2"]
        let citieNames = ["city1", "city2"]
        for i in 0..<2 {
            // Create background (cloud) and give name "background"
            let background = SKSpriteNode(imageNamed: bkgndNames[i])
            background.anchorPoint = CGPoint(x: 0, y: 0)
            background.position = CGPoint(x: CGFloat(i) * self.size.width, y: 0)
            background.name = "background"
            background.size = (self.size)
            background.zPosition = -2
            self.addChild(background)
            
            // Create background (city) and give name "city"
            let city = SKSpriteNode(imageNamed: citieNames[i])
            city.anchorPoint = CGPoint(x: 0, y: 0)
            city.position = CGPoint(x: CGFloat(i) * self.size.width, y: 0)
            city.name = "city"
            city.size = (self.size)
            city.zPosition = -1
            self.addChild(city)
        }
        
        sun = SKSpriteNode(imageNamed: "sun")
        sun.size = CGSize(width: shortLen / 7, height: shortLen / 7)
        sun.position = CGPoint(x: self.size.width * 5 / 6, y: self.size.height * 19 / 20)
        sun.zPosition = 0
        self.addChild(sun)
        
        scoreLbl.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 + self.size.height / 2.5)
        scoreLbl.text = "\(score)"
        scoreLbl.fontName = "04b_19"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 100
        self.addChild(scoreLbl)
        
        land = SKSpriteNode(imageNamed: "land")
        land.size = CGSize(width: self.frame.width * 1.4, height: self.frame.height / 16)
        land.position = CGPoint(x: self.size.width / 2, y: 0 + land.size.height / 2)
        
        land.physicsBody = SKPhysicsBody(rectangleOf: land.size)
        land.physicsBody?.categoryBitMask = TYPE_LAND
        land.physicsBody?.collisionBitMask = TYPE_FROG
        land.physicsBody?.contactTestBitMask  = TYPE_FROG
        land.physicsBody?.affectedByGravity = false
        land.physicsBody?.isDynamic = false
        
        land.zPosition = 3
        
        self.addChild(land)
        
        
        
        frog = SKSpriteNode(imageNamed: "frog")
        frog.size = CGSize(width: shortLen / 6, height: shortLen / 6)
        frog.position = CGPoint(x: self.size.width / 2 - frog.size.width, y: self.size.height / 2)
        
        frog.physicsBody = SKPhysicsBody(circleOfRadius: frog.size.height / 2)
        frog.physicsBody?.categoryBitMask = TYPE_FROG
        frog.physicsBody?.collisionBitMask = TYPE_LAND | TYPE_PIPE
        frog.physicsBody?.contactTestBitMask = TYPE_LAND | TYPE_PIPE | TYPE_APPLE
        frog.physicsBody?.affectedByGravity = false
        frog.physicsBody?.isDynamic = true
        
        frog.zPosition = 2
        
        
        self.addChild(frog)
        
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        createScene()
        
    }
    
    func createBtn(){
        
        restartBtn = SKSpriteNode(imageNamed: "restartbtn")
        restartBtn.size = CGSize(width: 200, height: 100)
        restartBtn.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
        
    }
    
    func createAngelBtn() {
        angelBtn = SKSpriteNode(imageNamed: "angel")
        angelBtn.size = CGSize(width: 200, height: 100)
        angelBtn.position = CGPoint(x: self.size.width / 2, y: self.size.height * 3 / 4)
        angelBtn.zPosition = 6
        angelBtn.setScale(0)
        self.addChild(angelBtn)
        angelBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    // Swift 3 version of "Did Begin Contact"
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        
        if firstBody.categoryBitMask == TYPE_APPLE && secondBody.categoryBitMask == TYPE_FROG{
            
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
            
        }
        else if firstBody.categoryBitMask == TYPE_FROG && secondBody.categoryBitMask == TYPE_APPLE {
            
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
            
        }
            
        else if(!practiceMode && (firstBody.categoryBitMask == TYPE_FROG && secondBody.categoryBitMask == TYPE_PIPE || firstBody.categoryBitMask == TYPE_PIPE && secondBody.categoryBitMask == TYPE_FROG)) {
            
            enumerateChildNodes(withName: "pipes", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            if (died == false){
                died = true
                createBtn()
            }
        }
        else if(!practiceMode && (firstBody.categoryBitMask == TYPE_FROG && secondBody.categoryBitMask == TYPE_LAND || firstBody.categoryBitMask == TYPE_LAND && secondBody.categoryBitMask == TYPE_FROG)){
            
            enumerateChildNodes(withName: "pipes", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            if (died == false){
                died = true
                createBtn()
            }
        }
        
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var checkToPracticeMode = false
        if gameStarted == false{
            
            gameStarted =  true
            checkToPracticeMode = true
            
            frog.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.run({
                () in
                
                self.generatePipes()
                
            })
            
            let delay = SKAction.wait(forDuration: 3.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            
            let distance = CGFloat(self.size.width + pipes.frame.size.width)
            let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            handlePipes = SKAction.sequence([movePipes, removePipes])
            
            frog.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            frog.physicsBody?.applyImpulse(CGVector(dx: 0, dy: frog.size.height * 2.5))
        }
        else{
            
            if died == true{
                
                
            }
            else{
                frog.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                frog.physicsBody?.applyImpulse(CGVector(dx: 0, dy: frog.size.height * 2.5))
            }
            
        }
        
        
        
        
        for touch in touches{
            let location = touch.location(in: self)
            
            if (died && restartBtn.contains(location)){
                restartScene()
            }
            if(checkToPracticeMode && angelBtn.contains(location)) {
                practiceMode = true
            }
        }
        
        
        if(checkToPracticeMode) {
            checkToPracticeMode = false
            angelBtn.removeFromParent()
        }
        
        
        
    }
    
    func generatePipes(){
        
        let appleNode = SKSpriteNode(imageNamed: "apple")
        
        appleNode.size = CGSize(width: 50, height: 50)
        appleNode.position = CGPoint(x: self.size.width + 25, y: self.size.height / 2)
        appleNode.physicsBody = SKPhysicsBody(rectangleOf: appleNode.size)
        appleNode.physicsBody?.affectedByGravity = false
        appleNode.physicsBody?.isDynamic = false
        appleNode.physicsBody?.categoryBitMask = TYPE_APPLE
        appleNode.physicsBody?.collisionBitMask = 0
        appleNode.physicsBody?.contactTestBitMask = TYPE_FROG
        appleNode.color = SKColor.blue
        
        
        pipes = SKNode()
        pipes.name = "pipes"
        
        let topPipe = SKSpriteNode(imageNamed: "pipeBottom")// Same image file. Just rotate around Z by 180 degrees.
        let btmPipe = SKSpriteNode(imageNamed: "pipeBottom")
        
        topPipe.size = CGSize(width: self.size.width / 7, height: self.size.height / 1.8);
        btmPipe.size = CGSize(width: self.size.width / 7, height: self.size.height / 1.8);
        
        topPipe.position = CGPoint(x: self.size.width + 25, y: self.size.height / 2 + self.size.height / 2.5)
        btmPipe.position = CGPoint(x: self.size.width + 25, y: self.size.height / 2 - self.size.height / 2.5)
        
        topPipe.physicsBody = SKPhysicsBody(rectangleOf: topPipe.size)
        topPipe.physicsBody?.categoryBitMask = TYPE_PIPE
        topPipe.physicsBody?.collisionBitMask = TYPE_FROG
        topPipe.physicsBody?.contactTestBitMask = TYPE_FROG
        topPipe.physicsBody?.isDynamic = false
        topPipe.physicsBody?.affectedByGravity = false
        
        btmPipe.physicsBody = SKPhysicsBody(rectangleOf: btmPipe.size)
        btmPipe.physicsBody?.categoryBitMask = TYPE_PIPE
        btmPipe.physicsBody?.collisionBitMask = TYPE_FROG
        btmPipe.physicsBody?.contactTestBitMask = TYPE_FROG
        btmPipe.physicsBody?.isDynamic = false
        btmPipe.physicsBody?.affectedByGravity = false
        
        topPipe.zRotation = CGFloat(M_PI)
        
        pipes.addChild(topPipe)
        pipes.addChild(btmPipe)
        
        pipes.zPosition = 1
        
        var randomPosition = Random.gen(min: -200, max: 200)
        pipes.position.y = pipes.position.y +  randomPosition
        pipes.addChild(appleNode)
        
        pipes.run(handlePipes)
        
        self.addChild(pipes)
        
    }
    
    
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if gameStarted == true{
            if died == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    
                    var bg = node as! SKSpriteNode
                    
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                        
                    }
                    
                }))
                
                enumerateChildNodes(withName: "city", using: ({
                    (node, error) in
                    
                    var bg = node as! SKSpriteNode
                    
                    bg.position = CGPoint(x: bg.position.x - 4, y: bg.position.y)
                    
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                        
                    }
                    
                }))
                
            }
            
            
        }
        
        
        
        
    }
}
