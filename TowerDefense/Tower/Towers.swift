//
//  Towers.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/5.
//

import Foundation

class Towers {
    let id: UUID
    var name: String
    var hp: Int
    var price: Int
    var cd: Int
    var level: Int
    var position: (Int,Int)
    
    init(name: String, hp: Int, price: Int, cd: Int, level: Int, position: (Int,Int)) {
        self.id = UUID()
        self.name = name
        self.hp = hp
        self.price = price
        self.cd = cd
        self.level = level
        self.position = position
    }
}



