//
//  HomeView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/12.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var viewModel = JsonModel.shared
    @Binding var level: Int
    @Binding var showView: Int
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    var body: some View {
        ZStack{
            Image("boss1.2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: ScreenSize.height)
                .position(x:ScreenSize.width * 0.1,y:ScreenSize.height * 0.9)
            Image("attacker2.3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: ScreenSize.height/2)
                .position(x:ScreenSize.width * 0.1,y:ScreenSize.height * 0.02)
            Image("attacker3.3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: ScreenSize.height/2)
                .position(x:ScreenSize.width * 0.9,y:ScreenSize.height * 0.8)
            Image("producer1.2.activated")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: ScreenSize.height)
                .position(x:ScreenSize.width * 0.9,y:ScreenSize.height * 0.1)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.8))
                .frame(width: ScreenSize.width * 0.95,height: ScreenSize.height * 0.95)
            VStack{
                Text("NOT ONLY")
                    .font(.system(size: 120))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text("TOWER DEFENSE")
                    .font(.system(size: 40))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                LazyVGrid(columns: columns,spacing: 20) {
                    ForEach(0..<10) { index in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.white)
                            .stroke(.black,lineWidth:3)
                            .frame(width: 90, height: 60)
                            .overlay(
                                Text("\(index + 1)")
                                    .font(.system(size: 24))
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            )
                            .onTapGesture {
                                if index < JsonModel.shared.levelItems.count {
                                    level = index
                                    showView = 2
                                }
                            }
                            .overlay(
                                index >= JsonModel.shared.levelItems.count ?
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.4))
                                    .frame(width: 90, height: 60)
                                : nil
                            )
                    }
                }
                .frame(width: ScreenSize.width * 0.6,height: ScreenSize.height * 0.25)
            
            }
            .foregroundColor(.black)
        }
        .background(Color.white)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}



