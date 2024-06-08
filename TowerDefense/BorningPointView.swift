//
//  BorningPointView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/8.
//

import SwiftUI

struct BorningPointView: View {
    var body: some View {
        Image("borningPoint")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:cellWidth * 0.9)
    }
}
