//
//  TowerView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/7.
//

import SwiftUI

struct TowerView: View {
    @State var showHpbar: Bool = true
    var angle: Double
    @ObservedObject var moneyManager = MoneyManager.shared
    var tower: Tower
    
    private var width: Double {
        return tower.radius * 2
    }

    var body: some View {
        ZStack(alignment: .top){
            Image(tower.img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(Angle(degrees: angle))
            if showHpbar {
                HPbarView(total: tower.originalHp, now: tower.hp, width: width)
                    .frame(width: width)
            }
        }
        .frame(width: width, height: width)
        .overlay{
            if(moneyManager.money >= tower.costToNextLevel && tower.level != 3){
                ZStack{
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .foregroundColor(Color.green.opacity(0.8))
                        .frame(width: width/2,height: width/2)
                }
               
            }
        }
        .onAppear(){
//            if let producerTower = tower as? ProducerTower {
//                withAnimation(.linear(duration: producerTower.produceInterval).repeatForever(autoreverses: false)) {
//                    angle = 360
//                }
//            }
        }
    }
}
