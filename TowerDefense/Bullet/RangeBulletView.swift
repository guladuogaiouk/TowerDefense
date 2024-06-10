//
//  RangeBulletView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/10.
//

import SwiftUI

struct RangeBulletView: View {
    var rangeBullet: RangeBullet
    var body: some View {
        Circle()
            .fill(Color.red.opacity(0.2))
            .stroke(Color.red)
            .frame(width: rangeBullet.range * cellWidth * 2 ,height: rangeBullet.range * cellWidth * 2)
    }
}

