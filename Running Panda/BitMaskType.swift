//
//  BitMaskType.swift
//  Running Panda
//
//  Created by 段昊宇 on 16/3/8.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

import Foundation

class BitMaskType {
    class var panda: UInt32 {
        return 1 << 0
    }
    class var platform: UInt32 {
        return 1 << 1
    }
    class var apple: UInt32 {
        return 1 << 2
    }
    class var scene: UInt32 {
        return 1 << 3
    }
}