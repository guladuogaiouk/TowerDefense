//
//  TowerView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/7.
//

import SwiftUI

struct TowerView: View {
    @State var showHpbar: Bool = false
    @Binding var angle: Double
    var tower: Tower
    var originalHP: Int {
        return tower.hp
    }
    private var width: Double {
        return ScreenSize.cellScale * 0.8
    }
    var body: some View {
        ZStack(alignment: .top){
            Image(tower.img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(Angle(degrees: angle))
            showHpbar ? HPbarView(total: originalHP, now: tower.hp, width: width)
                .frame(width: width)
            : nil
        }.frame(width: cellWidth * 0.8,height: cellHeight * 0.8)
    }
}
