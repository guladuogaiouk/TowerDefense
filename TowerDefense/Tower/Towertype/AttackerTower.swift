//
//  AttackerTower.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/6.
//

import Foundation
class AttackerTower: Tower {
    var range: Int{
        return 3
    }
    var attackSpeed: Double{
        return 0.2
    }
    override init(name: String, level: Int, position: (Int,Int)) {
        super.init(name: name, level: level, position: position)
    }
    override func createCopy(at position: (Int, Int)) -> AttackerTower {
        return AttackerTower(name: self.name, level: self.level, position: position)
    }
}
