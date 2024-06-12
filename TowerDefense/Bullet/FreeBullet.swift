//
//  FreeBullet.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/11.
//

import Foundation
@Observable
class FreeBullet: Identifiable{
    var id: UUID
    var name: String
    var level: Int
    var angle: Double
    var speed: Double = cellWidth * 2
    var initPosition: (Double,Double)
    var img: String = "boss1_bullet"
    var radius: Double = cellWidth * 0.15
    var attackValue: Int = 50
    init(angle: Double, initPosition: (Double, Double),name: String,level:Int) {
        self.id = UUID()
        self.angle = angle
        self.initPosition = initPosition
        self.name = name
        self.level = level
    }
}
