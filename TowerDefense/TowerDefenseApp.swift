//
//  TowerDefenseApp.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/5.
//

import SwiftUI

@main
struct TowerDefenseApp: App {
    @StateObject private var towerCardViews = TowerCardViews()
    @StateObject private var bulletData = BulletData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(TowerData.shared)
                .environmentObject(towerCardViews)
                .environmentObject(CoveredCells.shared)
                .environmentObject(MoneyManager.shared)
                .environmentObject(bulletData)
        }
    }
}



