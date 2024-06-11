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
    var iceTimer: Timer?
    var fireTimer: Timer?
    private var fireCount: Int = 0
    let id: UUID
    var name: String
    var speed: Double = 1.0
    var radius: Double = cellWidth * 0.3
    var originalHp: Int = 100
    var hp: Int = 100{
        didSet{
            if hp <= 0{
                if let index = EnemyData.shared.enemies.firstIndex(where: { $0 == self }){
                    EnemyData.shared.enemies.remove(at: index)
                    lastTurnPoint.remove(at: index)
                }
            }
            if hp <= originalHp / 2 && name == "boss1" && level != 2{
                self.speed /= 2
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.speed *= 4
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
    var isIced: Bool = false {
        didSet {
            if isIced {
                iceTimer?.invalidate()
                if iceTimer == nil {
                    self.speed /= 2
                }
                iceTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                    self.speed *= 2
                    self.iceTimer = nil
                    self.isIced = false
                }
            } else {
                if iceTimer != nil{
                    iceTimer?.invalidate()
                    iceTimer = nil
                    self.speed *= 2
                }
            }
        }
    }
    var isFired: Bool = false {
        didSet{
            if isFired {
                fireCount = 0
                fireTimer?.invalidate()
                fireTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                    self.hp -= 20
                    self.fireCount += 1
                    if self.fireCount >= 3 {
                        self.isFired = false
                        self.fireTimer?.invalidate()
                        self.fireTimer = nil
                    }
                }
            } else {
                fireCount = 0
                fireTimer?.invalidate()
                fireTimer = nil
            }
        }
        
    }
    init(name: String, position: (Double,Double) = (0,0), level: Int) {
        self.id = UUID()
        self.name = name
        self.position = position
        self.level = level
        switch(name){
            case "shield1" :
            self.speed = 0.8
                self.radius = cellWidth * 0.35
                switch(level){
                    case 1: self.originalHp = 100
                    case 2: self.originalHp = 200
                    case 3: self.originalHp = 300
                    default: break
                }
            case "boss1":
            self.speed = 0.6
                self.radius = cellWidth * 0.45
                self.originalHp = 500
            default: break
        }
        self.hp = self.originalHp
    }
}
