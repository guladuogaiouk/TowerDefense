//
//  Loseview.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/12.
//

import SwiftUI

struct LoseView: View {
    @Binding var showView: Int
    var body: some View {
        Text("Lose!")
        Text("Replay once!")
            .onTapGesture {
                showView = 2
            }
    }
}

