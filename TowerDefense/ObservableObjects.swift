//
//  ObservableObjects.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/8.
//

import Foundation
import SwiftUI

class CoveredCells: ObservableObject{
    @Published var coveredCells: [(Int,Int)] = []
}
//class MoneyManager: ObservableObject{
//    @Published var money: Int = 0
//}
class TowerData: ObservableObject{
    @Published var towers: [Tower] = []
}
class EnemyData: ObservableObject {
    @Published var enemies: [Enemy] = [
        AttackerEnemy(name: "shield1", position: (0, 0), level: 1),
        AttackerEnemy(name: "shield1", position: (0, 0), level: 2),
        AttackerEnemy(name: "shield1", position: (0, 0), level: 3),
        BossAttackEnemy(name: "boss1", position: (0, 0), level: 1)
    ]
}
class MoneyManager: ObservableObject {
    static let shared = MoneyManager()
    @Published var money = 2000
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
