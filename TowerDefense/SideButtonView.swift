//
//  SideButtonView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/8.
//

import SwiftUI

struct SideButtonView: View {
    @ObservedObject var towerData = TowerData.shared
    @ObservedObject var coveredCells = CoveredCells.shared
    @ObservedObject var moneyManager = MoneyManager.shared
    var tower: Tower
    var body: some View {
        ZStack{
            if let attackerTower = tower as? AttackerTower{
                Circle()
                    .fill(Color.black.opacity(0.1))
                    .stroke(Color.gray)
                    .frame(width: getRealLength(length: attackerTower.range) * 2,height: getRealLength(length: attackerTower.range) * 2)
            }
            Text("Lv.\(tower.level)")
                .foregroundStyle(Color.yellow)
                .font(.callout)
                .fontWeight(.bold)
            HStack{
                VStack(spacing: 3){
                    if tower.level == 3 {
                        ZStack {
                            RoundedRectangle(cornerRadius: 2).fill(Color.gray.opacity(0.6))
                                .frame(width: cellWidth * 0.4, height: cellHeight * 0.65)
                            VStack(spacing: 1) {
                                Image(systemName: "multiply.circle.fill")
                                    .resizable()
                                    .frame(width: cellWidth * 0.3, height: cellHeight * 0.3)
                                Text("MAX")
                                    .font(.footnote)
                            }
                        }
                    } else if moneyManager.money >= tower.costToNextLevel {
                        ZStack {
                            RoundedRectangle(cornerRadius: 2).fill(Color.green.opacity(0.6))
                                .frame(width: cellWidth * 0.4, height: cellHeight * 0.65)
                            VStack(spacing: 1) {
                                Image(systemName: "arrowshape.up.circle.fill")
                                    .resizable()
                                    .frame(width: cellWidth * 0.3, height: cellHeight * 0.3)
                                Text("\(tower.costToNextLevel)")
                                    .font(.footnote)
                            }
                        }
                        .onTapGesture {
                            if let index = towerData.towers.firstIndex(of: tower){
                                moneyManager.money -= towerData.towers[index].costToNextLevel
                                towerData.towers[index].level += 1
                                attackerTimers[index]?.invalidate()
                                attackerTimers[index] = nil
                            }
                           
                            
                        }
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 2).fill(Color.gray.opacity(0.6))
                                .frame(width: cellWidth * 0.4, height: cellHeight * 0.65)
                            VStack(spacing: 1) {
                                Image(systemName: "arrowshape.up.circle.fill")
                                    .resizable()
                                    .frame(width: cellWidth * 0.3, height: cellHeight * 0.3)
                                Text("\(tower.costToNextLevel)")
                                    .font(.footnote)
                            }
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 2).fill(Color.red.opacity(0.8))
                            .frame(width: cellWidth * 0.4,height: cellHeight * 0.4)
                        Image(systemName: "trash.fill")
                            .resizable()
                            .frame(width: cellWidth * 0.25,height: cellHeight * 0.25)
                    }
                    .onTapGesture {
                        attackerTimers[towerData.towers.firstIndex(of: tower)!]?.invalidate()
                        attackerTimers.remove(at: towerData.towers.firstIndex(of: tower)!)
                        towerData.towers.remove(at:towerData.towers.firstIndex(of: tower)!)
                        if let index = coveredCells.coveredCells.firstIndex(where: { $0 == tower.position }) {
                            coveredCells.coveredCells.remove(at: index)
                        }
                        
                    }
                }
                .offset(x:cellWidth * 0.6)
            }
        }
    }
}
//
//#Preview {
//    SideButtonView()
//}
