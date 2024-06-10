//
//  BulletView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/10.
//

import SwiftUI

struct BulletView: View {
    var bullet: Bullet
    var body: some View {
        Image(bullet.img)
            .resizable()
            .frame(width: bullet.radius,height: bullet.radius)
    }
}
