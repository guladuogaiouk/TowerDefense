//
//  AttackerTower.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/6.
//

import Foundation
class AttackerTower: Towers {
    var range: Int
    
    init(name: String, hp: Int, price: Int, cd: Int, level: Int, position: (Int,Int), range:  Int) {
        self.range = range
        super.init(name: name, hp: hp, price: price, cd: cd, level: level, position: position)
    }
}
