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
        return 1
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
    var towerIndex: Int
    var targetId: UUID
    var initPosition:(Double,Double)
    var targetPosition: (Double,Double)
    
    init(initPosition:(Double,Double),towerIndex: Int,targetId: UUID ,targetPosition: (Double,Double)) {
        self.id = UUID()
        self.initPosition = initPosition
        self.targetId = targetId
        self.towerIndex = towerIndex
        self.targetPosition = targetPosition
    }
}
