//
//  BossEnemy.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/6.
//

import Foundation
class BossAttackEnemy: AttackerEnemy{
    var upgradeHpPoint: Int = 50
    override init(name: String, position: (Double,Double), level: Int) {
        super.init(name: name, position: position, level: level)
    }
}
