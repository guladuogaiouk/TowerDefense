//
//  EnemyView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/6.
//

import SwiftUI

struct EnemyView: View {
    var img: String
    var body: some View {
//        Circle()
//            .fill(Color.red)
//            .frame(width: 50,height: 50)
        Image(img)
            .resizable()
            .frame(width: 50,height: 50)
    }
}

//#Preview {
//    EnemyView()
//}
