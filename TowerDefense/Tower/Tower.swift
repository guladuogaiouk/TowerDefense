//
//  Towers.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/5.
//

import Foundation

@Observable
class Tower: Identifiable,Equatable {
    static func == (lhs: Tower, rhs: Tower) -> Bool {
        return (lhs.name == rhs.name && lhs.level == rhs.level)
    }
    
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
    
    func createCopy(at position: (Int, Int)) -> Tower {
        return Tower(name: self.name, hp: self.hp, price: self.price, cd: self.cd, level: self.level, position: getRealPosition(position: position), img: self.img)
    }
}



