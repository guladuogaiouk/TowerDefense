//
//  Enemies.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/5.
//

import Foundation
class Enemies{
    let id: UUID
    var name: String
    var speed: Double
    var hp: Int
    var value: Int
    var position: (Int,Int)
    init(name: String, speed: Double, hp: Int, value: Int, position: (Int,Int)) {
        self.id = UUID()
        self.name = name
        self.speed = speed
        self.hp = hp
        self.value = value
        self.position = position
    }
}
