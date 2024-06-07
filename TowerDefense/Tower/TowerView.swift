//
//  TowerView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/7.
//

import SwiftUI

struct TowerView: View {
    var tower: Tower
    var body: some View {
        Image(tower.img)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

//#Preview {
//    TowerView()
//}
