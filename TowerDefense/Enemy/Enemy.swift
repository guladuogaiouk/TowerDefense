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
    var speed: Double = 1.0
    var radius: Double = cellWidth * 0.3
    var originalHp: Int = 100
    var hp: Int = 100
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
        switch(name){
            case "shield1" :
                self.speed = 1.0
                self.radius = cellWidth * 0.35
                switch(level){
                    case 1: self.originalHp = 100
                    case 2: self.originalHp = 200
                    case 3: self.originalHp = 300
                    default: break
                }
            case "boss1":
            self.speed = 0.8
                self.radius = cellWidth * 0.45
                switch(level){
                    case 1: self.originalHp = 500
                    case 2: self.originalHp = 1000
                    default: break
                }
            default: break
        }
        self.hp = self.originalHp
    }
}
