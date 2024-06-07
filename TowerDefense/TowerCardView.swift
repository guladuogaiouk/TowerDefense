//
//  TowerCardView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/7.
//

import SwiftUI

struct TowerCardView: View {
    var tower: Tower
    var body: some View {
        VStack{
            Image(tower.img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                
            HStack {
                Text("\(tower.price)")
                    .font(.headline)
//                    .padding(3)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.black)
            }
        }
    }
}

