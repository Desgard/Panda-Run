//
//  Platform.swift
//  Running Panda
//
//  Created by 段昊宇 on 16/3/7.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

import SpriteKit

class Platform: SKNode {
    var width: CGFloat = 0.0
    var height: CGFloat = 10.0
    var isDown = false
    var isShock = false
    
    // 创建平台
    func onCreat(arrSprite: [SKSpriteNode]) {
        for plantform in arrSprite {
            plantform.position.x = self.width
            self.addChild(plantform)
            self.width = plantform.size.width + self.width
        }
        
        // 只有三小块的平台会下落
        if arrSprite.count <= 3 {
            isDown = true
        } else {
            // 随机震动
            let random = arc4random() % 10
            if random > 6 {
                isShock = true
            }
        }
        
        self.height = 10.0
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.width, self.height), center: CGPointMake(self.width / 2,  0))
        self.physicsBody?.categoryBitMask = BitMaskType.platform
        self.physicsBody?.dynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
    }
}
