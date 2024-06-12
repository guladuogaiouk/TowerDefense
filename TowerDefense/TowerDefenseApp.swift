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
    @State var showView: Int = 1
    @State var level: Int = 0
    var body: some Scene {
        WindowGroup {
            switch showView {
                case 1:
                    HomeView(level: $level,showView: $showView)
                case 2:
                    ContentView(level: level,showView: $showView)
                        .environmentObject(TowerData.shared)
                        .environmentObject(towerCardViews)
                        .environmentObject(CoveredCells.shared)
                        .environmentObject(MoneyManager.shared)
                        .environmentObject(bulletData)
                case 3:
                    LoseView(showView: $showView)
                default:
                    AnyView(HomeView(level: $level,showView: $showView))
            }
        }
    }
}



