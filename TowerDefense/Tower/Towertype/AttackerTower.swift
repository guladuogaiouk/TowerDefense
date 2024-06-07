//
//  AttackerTower.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/6.
//

import Foundation
class AttackerTower: Tower {
    var range: Int = 3
    init(name: String, hp: Int, price: Int, cd: Int, level: Int, position: (Double,Double)) {
        let img =  "\(name).\(level)"
        super.init(name: name, hp: hp, price: price, cd: cd, level: level, position: position,img: img)
    }
}
