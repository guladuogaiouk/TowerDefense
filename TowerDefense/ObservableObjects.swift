//
//  ObservableObjects.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/8.
//

import Foundation
import SwiftUI
var enemies: [Enemy] = [
    AttackerEnemy(name: "shield1", level: 3),
    AttackerEnemy(name: "shield1", level: 1),
    AttackerEnemy(name: "shield1", level: 1),
    AttackerEnemy(name: "shield1", level: 2),
    AttackerEnemy(name: "shield1", level: 2),
    AttackerEnemy(name: "shield1", level: 3),
    BossAttackEnemy(name: "boss1", level: 1),
    BossAttackEnemy(name: "boss1", level: 1),
    BossAttackEnemy(name: "boss1", level: 1),
    BossAttackEnemy(name: "boss1", level: 1),
    BossAttackEnemy(name: "boss1", level: 1),
    BossAttackEnemy(name: "boss1", level: 1),
    BossAttackEnemy(name: "boss1", level: 1),
    BossAttackEnemy(name: "boss1", level: 1),
    BossAttackEnemy(name: "boss1", level: 1),
    BossAttackEnemy(name: "boss1", level: 1),
]
class CoveredCells: ObservableObject{
    @Published var coveredCells: [(Int,Int)] = []
}
class TowerData: ObservableObject{
    @Published var towers: [Tower] = []
}
class EnemyData: ObservableObject {
    static let shared = EnemyData()
    @Published var enemies: [Enemy] = []
}
class BulletData: ObservableObject{
    @Published var bullets: [Bullet] = []
    @Published var rangeBullets: [RangeBullet] = []
}
class MoneyManager: ObservableObject {
    static let shared = MoneyManager()
    @Published var money: Int = 1000
    private init() {}
}

class ScreenSize: ObservableObject {
    static let shared = ScreenSize()
    static var width: Double {
        UIScreen.main.bounds.width
    }
    static var height: Double {
        UIScreen.main.bounds.height
    }
    static var cellScale: Double {
        let cellWidth = ScreenSize.width / 15
        let cellHeight = ScreenSize.height / 9
        return min(cellWidth, cellHeight)
    }
    private init() {}
}
