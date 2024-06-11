//
//  FreeBulletView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/11.
//

import SwiftUI

struct FreeBulletView: View {
    var freeBullet: FreeBullet
    var body: some View {
        Image(freeBullet.img)
            .resizable()
            .frame(width: freeBullet.radius * 2,height: freeBullet.radius * 2)
            .rotationEffect(Angle(radians: freeBullet.angle))
    }
}

