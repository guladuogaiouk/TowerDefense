//
//  TowerView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/7.
//

import SwiftUI

struct TowerView: View {
    @State var showHpbar: Bool = false
    @State var isShowSideButtons: Bool = false
    @State var angle: Double = 0
    @Binding var trigger: Bool
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
        .onAppear(){
            withAnimation(.linear(duration: 5)){
                angle = 1080
            }
        }
        .overlay{
            isShowSideButtons ?
            HStack{
                Spacer()
                VStack(spacing: 3){
                    tower.level == 3 ?
                    ZStack{
                        RoundedRectangle(cornerRadius: 2).fill(Color.green.opacity(0.6))
                            .frame(width: cellWidth * 0.4,height: cellHeight * 0.65)
                        VStack(spacing:1){
                            Image(systemName: "arrowshape.up.circle.fill")
                                .resizable()
                                .frame(width: cellWidth * 0.3,height: cellHeight * 0.3)
                            Text("\(tower.price)")
                                .font(.footnote)
                        }
                    }
                    :
                    ZStack{
                        RoundedRectangle(cornerRadius: 2).fill(Color.gray.opacity(0.6))
                            .frame(width: cellWidth * 0.4,height: cellHeight * 0.65)
                        VStack(spacing:1){
                            Image(systemName: "multiply.circle.fill")
                                .resizable()
                                .frame(width: cellWidth * 0.3,height: cellHeight * 0.3)
                            Text("MAX")
                                .font(.footnote)
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 2).fill(Color.red.opacity(0.8))
                            .frame(width: cellWidth * 0.4,height: cellHeight * 0.4)
                        Image(systemName: "trash.fill")
                            .resizable()
                            .frame(width: cellWidth * 0.25,height: cellHeight * 0.25)
                    }
                   
                }
                .offset(x:cellWidth * 0.4)
            }
            : nil
        }
        .onChange(of: trigger){
            isShowSideButtons = trigger
        }
    }
}
