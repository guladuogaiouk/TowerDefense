//
//  Towers.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/5.
//

import Foundation

@Observable
class Tower: Identifiable,Equatable {
    static func == (lhs: Tower, rhs: Tower) -> Bool {
        return (lhs.name == rhs.name && lhs.level == rhs.level)
    }
    
    let id: UUID
    var name: String
    var hp: Int{
        return 100
    }
    var price: Int{
        return 100
    }
    var cd: Int{
        return 10
    }
    var level: Int
    var costToNextLevel: Int{
        switch(level){
            case 1: 50;
            case 2:100;
            case 3:0;
            default:0;
        }
    }
    var position: (Int,Int)
    var img: String{
        return "\(name).\(level)"
    }
    
    init(name: String, level: Int, position: (Int,Int)) {
        self.id = UUID()
        self.name = name
        self.level = level
        self.position = position
    }
    
    func createCopy(at position: (Int, Int)) -> Tower {
        return Tower(name: self.name, level: self.level, position: position)
    }
}



