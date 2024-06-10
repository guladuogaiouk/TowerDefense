//
//  TowerDefenseApp.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/5.
//

import SwiftUI

@main
struct TowerDefenseApp: App {
    @StateObject private var towerData = TowerData()
    @StateObject private var towerCardViews = TowerCardViews()
    @StateObject private var coveredCells = CoveredCells()
    @StateObject private var bulletData = BulletData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(towerData)
                .environmentObject(towerCardViews)
                .environmentObject(coveredCells)
                .environmentObject(MoneyManager.shared)
                .environmentObject(bulletData)
        }
    }
}



