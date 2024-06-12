//
//  ObservableObjects.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/8.
//

import Foundation
import SwiftUI

var enemyWaves: [EnemyWave] = []
var path: [(Int,Int)] = []
var towerCards: [Tower] = []

class CoveredCells: ObservableObject{
    static let shared = CoveredCells()
    @Published var coveredCells: [(Int,Int)] = []
}
class TowerData: ObservableObject{
    static let shared = TowerData()
    @Published var towers: [Tower] = []
    @Published var towerRotateAngles: [Double] = []
}
class EnemyData: ObservableObject {
    static let shared = EnemyData()
    @Published var enemies: [Enemy] = []
}
class BulletData: ObservableObject{
    @Published var bullets: [Bullet] = []
    @Published var rangeBullets: [RangeBullet] = []
    @Published var enemyFreeBullets: [FreeBullet] = []
}
class MoneyManager: ObservableObject {
    static let shared = MoneyManager()
    @Published var money: Int = 0
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
