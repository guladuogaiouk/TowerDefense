//
//  RangeBullet.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/10.
//

import Foundation
@Observable
class RangeBullet: Identifiable{
    let id: UUID
    var attackValue: Int = 0
    var attackSpeed: Double
    var range: Double
    var img: String{
        return "shield1.1"
    }
    var initPosition:(Double,Double)
    var name: String
    var level: Int
    init(initPosition: (Double, Double), name: String, level: Int, range: Double, attackSpeed: Double) {
        self.id = UUID()
        self.initPosition = initPosition
        self.name = name
        self.level = level
        self.range = range
        self.attackSpeed = attackSpeed
        switch name{
            case "attacker4":
            switch level{
                case 1: self.attackValue = 5
                case 2: self.attackValue = 6
                case 3: self.attackValue = 7
                default: break
            }
        default: break;
        }
    }
}
