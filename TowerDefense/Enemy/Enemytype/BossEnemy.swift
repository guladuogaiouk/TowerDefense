//
//  BossEnemy.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/6.
//

import Foundation
class BossAttackEnemy: AttackerEnemy{
    override init(name: String, position: (Double,Double) = (0,0), level: Int) {
        super.init(name: name, position: position, level: level)
    }
}
