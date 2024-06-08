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

class TowerData: ObservableObject{
    @Published var towers: [Tower] = []
}
class EnemyData: ObservableObject {
    @Published var enemies: [Enemy] = [
        AttackerEnemy(name: "shield1", speed: 1, hp: 100, value: 25, position: (0, 0), level: 1),
        AttackerEnemy(name: "shield1", speed: 0.8, hp: 100, value: 25, position: (0, 0), level: 2),
        AttackerEnemy(name: "shield1", speed: 1.2, hp: 100, value: 25, position: (0, 0), level: 3),
        BossAttackEnemy(name: "boss1", speed: 0.7, hp: 500, value: 100, position: (0, 0), level: 1)
    ]
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
