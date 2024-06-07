//
//  TowerDefenseApp.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/5.
//

import SwiftUI

@main
struct TowerDefenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
//func getCellScale() -> Double{
//    let screenBounds = UIScreen.main.bounds
//    let width = screenBounds.width
//    let height = screenBounds.height
//    let cellWidth = width / 15
//    let cellHeight = height * 0.9 / 9
//    return cellWidth < cellHeight ? cellWidth : cellHeight
//}


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



