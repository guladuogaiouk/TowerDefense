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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(towerData)
        }
    }
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



