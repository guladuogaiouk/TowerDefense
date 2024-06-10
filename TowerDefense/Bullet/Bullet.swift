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
    var attackValue: Int{
        return 5
    }
    var radius: Double{
        return cellWidth * 0.15
    }
    var img: String{
        return "shield1.1"
    }
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
    }
}
