//
//  DestinationPointView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/11.
//

import SwiftUI

struct DestinationPointView: View {
    var body: some View {
        Image("destinationPoint")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:cellWidth * 0.9)
    }
}
