//
//  HomeView.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/12.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = JsonModel()
    @Binding var level: Int
    @Binding var showView: Int
    
    var body: some View {
        ForEach(0..<5){ index in
            Text("\(index)")
                .onTapGesture {
                    showView = 2
                    level = index
                }
        }
    }
}


