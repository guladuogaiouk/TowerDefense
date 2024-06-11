//
//  AttackerEmemy.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/7.
//

import Foundation
class AttackerEnemy: Enemy{
    var range: Int{
        return 1
    }
    var attackInterval: TimeInterval{
        return 0.2
    }
    override init(name: String, position: (Double,Double) = (0,0), level: Int) {
        super.init(name: name, position: position,level: level)
    }
}
