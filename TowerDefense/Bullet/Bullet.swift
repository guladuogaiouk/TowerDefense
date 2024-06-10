//
//  Bullets.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/6.
//

import Foundation
@Observable
class Bullet: Identifiable{
    let id: UUID
    var attackValue: Int = 0
    var radius: Double{
        return cellWidth * 0.2
    }
    var img: String = "normal"
    var flySpeed: Double{
        return cellWidth * 3
    }
    var angle: Double = 0
    var targetId: UUID
    var initPosition:(Double,Double)
    var name: String
    var level: Int
    init(initPosition:(Double,Double), targetId: UUID ,name: String, level: Int) {
        self.id = UUID()
        self.initPosition = initPosition
        self.targetId = targetId
        self.name = name
        self.level = level
        switch name{
            case "attacker1": 
                self.img = "normal"
                self.attackValue = 3
            case "attacker2":
                self.img = "fire"
                self.attackValue = 5
            case "attacker3":
                self.img = "ice"
                self.attackValue = 3
            default: break
        }
    }
}
