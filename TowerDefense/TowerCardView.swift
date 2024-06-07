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
//                Image(systemName: "cross.fill")
//                    .font(.caption)
                Text("\(tower.price)")
                    .font(.headline)
//                    .padding(3)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
//            .background(Color(red: 217/255, green: 217/255, blue: 217/255))
        }
    }
}
//
//#Preview {
//    TowerCardView()
//}
