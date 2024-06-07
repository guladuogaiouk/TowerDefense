//
//  AttackerTower.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/6.
//

import Foundation
class AttackerTower: Tower {
    var range: Int
    
    init(name: String, hp: Int, price: Int, cd: Int, level: Int, position: (Double,Double),img: String, range:  Int) {
        self.range = range
        super.init(name: name, hp: hp, price: price, cd: cd, level: level, position: position,img: img)
    }
}
