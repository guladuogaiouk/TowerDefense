//
//  RangeAttackerTower.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/10.
//

import Foundation
class RangeAttackerTower: AttackerTower{
    override init(name: String, level: Int, position: (Int, Int)) {
        super.init(name: name, level: level, position: position)
    }
    override func createCopy(at position: (Int, Int)) -> RangeAttackerTower {
        return RangeAttackerTower(name: self.name, level: self.level, position: position)
    }
}
