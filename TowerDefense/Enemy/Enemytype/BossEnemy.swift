//
//  BossEnemy.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/6.
//

import Foundation
class BossAttackEnemy: AttackerEnemy{
    var upgradeHpPoint: Int = 100
    override init(name: String, speed: Double, hp: Int, value: Int, position: (Double,Double),level: Int) {
        super.init(name: name, speed: speed, hp: hp, value: value, position: position,level: level)
    }
}
