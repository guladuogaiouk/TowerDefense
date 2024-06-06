//
//  Enemies.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/5.
//

import Foundation
import Combine

@Observable
class Enemy: Identifiable{
    let id: UUID
    var name: String
    var speed: Double
    var hp: Int
    var value: Int
    var position: (Double,Double)
    init(name: String, speed: Double, hp: Int, value: Int, position: (Double,Double)) {
        self.id = UUID()
        self.name = name
        self.speed = speed
        self.hp = hp
        self.value = value
        self.position = position
    }
}
