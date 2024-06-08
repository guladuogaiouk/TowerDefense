//
//  AttackerTower.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/6.
//

import Foundation
class AttackerTower: Tower {
    var range: Int = 3
    override init(name: String, hp: Int, price: Int, cd: Int, level: Int, position: (Int,Int)) {
        super.init(name: name, hp: hp, price: price, cd: cd, level: level, position: position)
    }
    override func createCopy(at position: (Int, Int)) -> AttackerTower {
        return AttackerTower(name: self.name, hp: self.hp, price: self.price, cd: self.cd, level: self.level, position: position)
    }
}
