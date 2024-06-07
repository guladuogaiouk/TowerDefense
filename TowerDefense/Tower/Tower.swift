//
//  Towers.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/5.
//

import Foundation

@Observable
class Tower: Identifiable {
    let id: UUID
    var name: String
    var hp: Int
    var price: Int
    var cd: Int
    var level: Int
    var position: (Double,Double)
    var img: String
    
    init(name: String, hp: Int, price: Int, cd: Int, level: Int, position: (Double,Double),img: String) {
        self.id = UUID()
        self.name = name
        self.hp = hp
        self.price = price
        self.cd = cd
        self.level = level
        self.position = position
        self.img = img
    }
}



