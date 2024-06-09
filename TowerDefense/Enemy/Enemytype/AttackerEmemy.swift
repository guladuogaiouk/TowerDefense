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
    override init(name: String, position: (Double,Double), level: Int) {
        super.init(name: name, position: position,level: level)
    }
}
