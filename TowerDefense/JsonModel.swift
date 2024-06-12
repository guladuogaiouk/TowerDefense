//
//  JsonModel.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/12.
//

import Foundation
import SwiftUI

struct ItemJson: Decodable {
//    var id = UUID()
    var type: String
    var name: String
}

struct EnemyWaveJson: Decodable {
    var wave: Int
    var enemies: [ItemJson]
}

struct LevelItem: Identifiable, Decodable {
    var id = UUID()  
    var level_id: Int
    var original_money: Int
    var path: [(Int, Int)]
    var towers: [ItemJson]
    var enemies: [EnemyWaveJson]

    private enum CodingKeys: String, CodingKey {
        case level_id, original_money, path, towers, enemies
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        level_id = try container.decode(Int.self, forKey: .level_id)
        original_money = try container.decode(Int.self, forKey: .original_money)
        towers = try container.decode([ItemJson].self, forKey: .towers)
        enemies = try container.decode([EnemyWaveJson].self, forKey: .enemies)

        let pathArray = try container.decode([[Int]].self, forKey: .path)
        path = pathArray.map { ($0[0], $0[1]) }
    }
}

class JsonModel: ObservableObject {
    @Published var levelItems: [LevelItem] = []
    init() {
        loadJSON()
    }
    
    func loadJSON() {
        if let url = Bundle.main.url(forResource: "allData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode([LevelItem].self, from: data)
                self.levelItems = decodedData
            } catch {
                print("Failed to load or decode JSON: \(error)")
            }
        }
    }
}
