//
//  EnemyView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/6.
//

import SwiftUI

struct EnemyView: View {
    var enemy: Enemy
    private var width: Double {
        return enemy.name.starts(with: "shield") ? ScreenSize.cellScale * 0.7 : ScreenSize.cellScale * 1.1
    }
    var body: some View {
        Image(enemy.img)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width)
    }
}
