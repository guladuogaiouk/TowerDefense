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
        if tower is AttackerTower {
            return cellWidth * 0.9
        }else if tower is ProducerTower{
            return cellWidth * 0.7
        }
        return cellWidth * 0.8
    }

    var body: some View {
        ZStack(alignment: .top){
            Image(tower.img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(Angle(degrees: angle))
            if showHpbar {
                HPbarView(total: originalHP, now: tower.hp, width: width)
                    .frame(width: width)
            }
        }
        .frame(width: width, height: width)
        .onAppear(){
            if let producerTower = tower as? ProducerTower {
                withAnimation(.linear(duration: producerTower.produceInterval).repeatForever(autoreverses: false)) {
                    angle = 360
                }
            }
        }
    }
}
