//
//  TowerCardView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/7.
//

import SwiftUI

struct TowerCardView: View {
    @ObservedObject var viewModel: TowerCardViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Image(viewModel.tower.img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                HStack {
                    Text("\(viewModel.tower.price)")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.black)
                }
            }
            .padding(10)
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .frame(height: cellHeight * viewModel.waitingRatio)
        }
        .frame(width: cellWidth * 0.8, height: cellHeight * 1.0)
    }
}


class TowerCardViewModel: ObservableObject {
    @Published var waitingRatio: Double = 1
    @Published var isCoolingDown: Bool = false
    var tower: Tower
    init(tower: Tower) {
        self.tower = tower
    }
    
    func startWaiting() {
        waitingRatio = 1
        isCoolingDown = true
        withAnimation(.linear(duration: TimeInterval(tower.cd))) {
            waitingRatio = 0
        } completion: {
            self.isCoolingDown = false 
        }
    }
}

