//
//  Panda.swift
//  Running Panda
//
//  Created by 段昊宇 on 16/3/7.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

import SpriteKit

enum Status: Int {
    case run = 1, jump, jump2, roll;
}

class Panda: SKSpriteNode {
    
    let runAtlas = SKTextureAtlas(named: "run.atlas")
    var runFrames = [SKTexture]()
    
    let jumpAtlas = SKTextureAtlas(named: "jump.atlas")
    var jumpFrames = [SKTexture]()
    
    let rollAtlas = SKTextureAtlas(named: "roll.atlas")
    var rollFrames = [SKTexture]()
    
    var status = Status.run
    
    var jumpStart = 0.0
    var jumpEnd = 0.0
    
    // 增加跳跃效果
    let jumpEffectAtlas = SKTextureAtlas(named: "jump_effect.atlas")
    var jumpEffectFrames = [SKTexture]()
    var jumpEffect = SKSpriteNode()
    
    init() {
        let texture = runAtlas.textureNamed("panda_run_01")
        let size = texture.size()
        super.init(texture: texture, color: UIColor.whiteColor(), size: size)
        
        var i:Int
        for i = 1; i <= runAtlas.textureNames.count; i++ {
            let tempName = String(format: "panda_run_0%d", i)
            let runTexture = runAtlas.textureNamed(tempName)
            runFrames.append(runTexture)
        }
        
        for i = 1; i <= jumpAtlas.textureNames.count; i++ {
            let tempName = String(format: "panda_jump_0%d", i)
            let jumpTexture = jumpAtlas.textureNamed(tempName)
            jumpFrames.append(jumpTexture)
        }
        
        for i = 1; i <= rollAtlas.textureNames.count; i++ {
            let tempName = String(format: "panda_roll_0%d", i)
            let rollTexture = rollAtlas.textureNamed(tempName)
            rollFrames.append(rollTexture)
        }
        for i = 1; i <= jumpEffectAtlas.textureNames.count; i++ {
            let tempName = String(format: "jump_effect_0%d", i)
            let effectexture = jumpEffectAtlas.textureNamed(tempName)
            jumpEffectFrames.append(effectexture)
        }
        self.physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        self.physicsBody!.dynamic = true
        self.physicsBody!.allowsRotation = false
        // 摩擦力
        self.physicsBody!.restitution = 0.1
        self.physicsBody!.categoryBitMask = BitMaskType.panda
        self.physicsBody?.contactTestBitMask = BitMaskType.scene | BitMaskType.platform
        self.physicsBody?.collisionBitMask = BitMaskType.platform
        
        run()
    }
    
    func run() {
        self.removeAllActions()
        self.status = .run
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runFrames, timePerFrame: 0.05)))
    }
    
    func jump() {
        self.removeAllActions()
        if status != Status.jump2 {
            self.runAction(SKAction.animateWithNormalTextures(jumpFrames, timePerFrame: 0.05))
            self.physicsBody?.velocity = CGVectorMake(0, 900)
            if status == Status.jump {
                status = Status.jump2
                self.jumpStart = Double(self.position.y)
            } else {
                status = Status.jump
            }
        }
        // self.runAction(SKAction.animateWithTextures(jumpFrames, timePerFrame: 0.05))
    }
    
    func roll() {
        self.removeAllActions()
        self.status = .roll
        self.runAction(SKAction.animateWithTextures(rollFrames, timePerFrame: 0.05), completion: {() in
                self.run()
            })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
