//
//  PlatformFactory.swift
//  Running Panda
//
//  Created by 段昊宇 on 16/3/7.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

import SpriteKit

class PlatformFactory: SKNode {
    let textureLeft = SKTexture(imageNamed: "platform_l")
    let textureMid = SKTexture(imageNamed: "platform_m")
    let textureRight = SKTexture(imageNamed: "platform_r")
    
    var platforms = [Platform]()
    var sceneWidth: CGFloat = 0
    var delegate: ProtocoMainScene?
    
    func createPlatorRandom () {
        // 随机创建平台长度
        let midNum: UInt32 = (arc4random() % 4 + 1)
        
        // 平台间隔参数
        let gap: CGFloat = CGFloat(arc4random() % 8 + 1)
        
        // x 坐标
        let x: CGFloat = self.sceneWidth + CGFloat(midNum * 50) + gap + 100
        
        let y: CGFloat = CGFloat(arc4random() % 200 + 200)
        
        createPlatform(midNum, x: x, y: y)
    }
    
    func createPlatform(midNum: UInt32, x: CGFloat, y: CGFloat) {
        let platform = Platform()
        let platform_left = SKSpriteNode(texture: textureLeft)
        platform_left.anchorPoint = CGPointMake(0, 0.9)
        
        let platform_right = SKSpriteNode(texture: textureRight)
        platform_right.anchorPoint = CGPointMake(0, 0.9)
        
        var arrPlatform = [SKSpriteNode]()
        
        arrPlatform.append(platform_left)
        platform.position = CGPointMake(x, y)
        
        for i in 1...midNum {
            let platform_mid = SKSpriteNode(texture: textureMid)
            platform_mid.anchorPoint = CGPointMake(0, 0.9)
            arrPlatform.append(platform_mid)
        }
        arrPlatform.append(platform_right)
        
        platform.onCreat(arrPlatform)
        self.addChild(platform)
        
        platforms.append(platform)
        
        // 通用公式：平台的长度 + x坐标 - 主场景的宽度
        delegate?.onGetData(platform.width + x - sceneWidth)
        
    }
    
    func move(speed: CGFloat) {
        for p in platforms {
            p.position.x -= speed
        }
        if platforms[0].position.x < -platforms[0].width {
            platforms[0].removeFromParent()
            platforms.removeAtIndex(0)
        }
    }
    func reset() {
        self.removeAllChildren()
        platforms.removeAll(keepCapacity: false)
    }
}


 