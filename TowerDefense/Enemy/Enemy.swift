//
//  Enemies.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/5.
//

import Foundation
import Combine

@Observable
class Enemy: Identifiable,Equatable{
    static func == (lhs: Enemy, rhs: Enemy) -> Bool {
        return lhs.id == rhs.id
    }
    let id: UUID
    var name: String
    var speed: Double{
        return 1.0
    }
    var hp: Int{
        return 100
    }
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
    }
}
