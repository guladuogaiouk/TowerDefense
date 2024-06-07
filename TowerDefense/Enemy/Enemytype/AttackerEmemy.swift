//
//  AttackerEmemy.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/7.
//

import Foundation
class AttackerEnemy: Enemy{
    var attack: Int = 25
    var range: Int = 3
    init(name: String, speed: Double, hp: Int, value: Int, position: (Double,Double), level: Int) {
        let img = "\(name).\(level)"
        super.init(name: name, speed: speed, hp: hp, value: value, position: position, img: img,level: level)
    }
}
