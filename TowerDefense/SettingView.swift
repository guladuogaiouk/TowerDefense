//
//  WinView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/12.
//

import SwiftUI

struct SettingView: View {
    @Binding var showView: Int
    @Binding var level: Int
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
                Text("TRY AGAIN?")
                    .font(.system(size: 120))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                HStack(spacing:cellWidth){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .stroke(.black,lineWidth:3)
                        .frame(width: 180, height: 80)
                        .overlay(
                            Text("REPLAY")
                                .font(.system(size: 24))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        )
                        .onTapGesture {
                            showView = 2
                        }
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .stroke(.black,lineWidth:3)
                        .frame(width: 180, height: 80)
                        .overlay(
                            Text("RETURN")
                                .font(.system(size: 24))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        )
                        .onTapGesture {
                            showView = 1
                        }
                    
                }
            }
            .foregroundColor(.black)
        }
        .background(Color.white)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}
