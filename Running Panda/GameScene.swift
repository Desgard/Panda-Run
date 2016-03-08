//
//  GameScene.swift
//  Running Panda
//
//  Created by 段昊宇 on 16/3/7.
//  Copyright (c) 2016年 Desgard_Duan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, ProtocoMainScene , SKPhysicsContactDelegate {
    lazy var panda = Panda()
    lazy var platformFactory = PlatformFactory()
    
    var moveSpeed :CGFloat = 15.0
    var maxSpeed :CGFloat = 50.0
    var distance:CGFloat = 0.0
    var lastDis:CGFloat = 0.0
    var theY:CGFloat = 0.0
    var isLose = false
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask) | (contact.bodyB.categoryBitMask) == (BitMaskType.scene | BitMaskType.panda) {
            isLose = true
            print("游戏结束")
        }
        
        
        // 熊猫和平台碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.platform | BitMaskType.panda) {
            var isDown = false
            var canRun = false
            if contact.bodyA.categoryBitMask == BitMaskType.platform {
                if (contact.bodyA.node as! Platform).isDown {
                    isDown = true
                    contact.bodyA.node!.physicsBody!.dynamic = true
                    contact.bodyA.node!.physicsBody!.collisionBitMask = 0
                }else if (contact.bodyA.node as! Platform).isShock {
                    (contact.bodyA.node as! Platform).isShock = false
                    downAndUp(contact.bodyA.node!, down: -50, downTime: 0.2, up: 100, upTime: 1, isRepeat: true)
                }
                if contact.bodyB.node!.position.y > contact.bodyA.node!.position.y {
                    canRun = true
                }
                
            } else if contact.bodyB.categoryBitMask == BitMaskType.platform {
                if (contact.bodyB.node as! Platform).isDown {
                    contact.bodyB.node!.physicsBody?.dynamic = true
                    contact.bodyB.node?.physicsBody?.collisionBitMask = 0
                    isDown = true
                }
                if contact.bodyA.node!.position.y > contact.bodyB.node!.position.y {
                    canRun = true
                }
            }
            panda.jumpEnd = Double(panda.position.y)
            if panda.jumpEnd-panda.jumpStart <= -70 {
                panda.roll()
                if !isDown {
                    downAndUp(contact.bodyA.node!)
                    downAndUp(contact.bodyB.node!)
                }
            } else {
                if canRun {
                    panda.run()
                }
                
            }
        }
        // 落地后jumpstart数据要设为当前位置，防止自由落地计算出错
        panda.jumpStart = Double(panda.position.y)
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        panda.jumpStart = Double(panda.position.y)
        
    }
    func downAndUp(node: SKNode, down: CGFloat = -50, downTime: CGFloat = 0.05, up: CGFloat = 50, upTime: CGFloat = 0.1, isRepeat: Bool = false){
        let downAct = SKAction.moveByX(0, y: down, duration: Double(downTime))
        let upAct = SKAction.moveByX(0, y: up, duration: Double(upTime))
        let downUpAct = SKAction.sequence([downAct,upAct])
        if isRepeat {
            node.runAction(SKAction.repeatActionForever(downUpAct))
        }else {
            node.runAction(downUpAct)
        }
        
        
    }
    
    override func didMoveToView(view: SKView) {
        let skyColor = SKColor(red: 113/255, green: 197/255, blue: 207/255, alpha: 1)
        
        self.backgroundColor = skyColor
        
        // 背景
        
        // 物理碰撞检测
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -20)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody!.categoryBitMask = BitMaskType.scene
        self.physicsBody!.dynamic = false
        
        panda.position = CGPointMake(200, 400);
        self.addChild(panda)
        
        self.addChild(platformFactory)
        platformFactory.delegate = self
        platformFactory.sceneWidth = self.frame.size.width
        platformFactory.createPlatform(5, x: 0, y: 200)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isLose {
            reSet()
        } else {
            panda.jump()
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        lastDis = lastDis - moveSpeed
        if  lastDis <= 0 {
            print("生成新平台")
            // platformFactory.createPlatform(1, x: 1500, y: 200)
            platformFactory.createPlatorRandom()
        }
        platformFactory.move(moveSpeed)
    }
    
    func onGetData(dist: CGFloat) {
        self.lastDis = dist
    }
    
    // 重新开始游戏
    func reSet() {
        isLose = false
        panda.position = CGPointMake(200, 400)
        moveSpeed  = 15.0
        distance = 0.0
        lastDis = 0.0
        platformFactory.reset()
        platformFactory.createPlatform(3, x: 0, y: 200)
    }
}

protocol ProtocoMainScene {
    func onGetData(dist: CGFloat)
}