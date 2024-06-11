//
//  Enemies.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/5.
//

import Foundation
import Combine
import SwiftUI

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
    var hp: Int = 100{
        didSet{
            if hp <= originalHp / 2 && name == "boss1" && level != 2{
                let originalSpeed = self.speed
                self.speed = 0.2
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.speed = originalSpeed * 3
                }
                self.level = 2
                withAnimation(.linear(duration:1)){
                    self.radius = self.radius * 1.3
                }
            }
        }
    }
    var position: (Double,Double) = (0,0)
    var img: String{
        return "\(name).\(level)"
    }
    var level: Int
    
    init(name: String, position: (Double,Double) = (0,0), level: Int) {
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
                self.originalHp = 1000
            default: break
        }
        self.hp = self.originalHp
    }
}
