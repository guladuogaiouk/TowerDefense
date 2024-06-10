//
//  Enemies.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/5.
//

import Foundation
import Combine

@Observable
class Enemy: Identifiable,Equatable,ObservableObject{
    static func == (lhs: Enemy, rhs: Enemy) -> Bool {
        return lhs.id == rhs.id
    }
    let id: UUID
    var name: String
    var speed: Double{
        return 1.0
    }
    var radius: Double{
        return cellWidth * 0.4
    }
    let originalHp: Int
    var hp: Int
    var position: (Double,Double)
    var img: String{
        return "\(name).\(level)"
    }
    var level: Int
    
    init(name: String, position: (Double,Double), level: Int) {
        self.id = UUID()
        self.name = name
        self.position = position
        self.level = level
        self.originalHp = 100
        self.hp = self.originalHp
    }
}
