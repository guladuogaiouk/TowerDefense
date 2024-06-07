//
//  TowerCardView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/7.
//

import SwiftUI

struct TowerCardView: View {
    @State var waitingRatio: Double = 0
    var tower: Tower
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                Image(tower.img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
                HStack {
                    Text("\(tower.price)")
                        .font(.headline)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(Color.black)
                }
            }
            .padding(10)
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .frame(height: cellHeight * waitingRatio)
        }
        .frame(width: cellWidth * 0.8, height: cellHeight * 1.0)
        .onAppear(){
            startWaiting(cd: 8)
        }
    }
    func startWaiting(cd: Int){
        waitingRatio = 1
        withAnimation(.linear(duration:TimeInterval(cd))){
            waitingRatio = 0
        }
    }
}

