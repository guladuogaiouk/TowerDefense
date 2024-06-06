//
//  BossEnemy.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/6.
//

import Foundation
class AttackerEnemy: Enemy{
    var attack: Int
    var range: Int
    init(name: String, speed: Double, hp: Int, value: Int, position: (Double,Double),img: String, attack: Int, range: Int) {
        self.attack = attack
        self.range = range
        super.init(name: name, speed: speed, hp: hp, value: value, position: position, img: img)
    }
}
