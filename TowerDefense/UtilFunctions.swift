//
//  UtilFunctions.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/9.
//

import Foundation
func getDistance(position1:(Double,Double),position2:(Double,Double))->Double{
    return sqrt(pow(position1.0-position2.0, 2) + pow(position1.1-position2.1, 2))
}
func getRealDistance(towerPositionInt: (Int,Int), enemyPosition:(Double,Double))->Double{
    let towerPosition = getRealPosition(position: towerPositionInt)
    return getDistance(position1: towerPosition, position2: enemyPosition)
}
func getRealPosition(position: (Int, Int)) -> (Double, Double) {
    let real_x = Double(position.0) * cellWidth - cellWidth / 2
    let real_y = Double(10 - position.1) * cellHeight - cellHeight / 2
    return (real_x, real_y)
}
func getRealLength(length: Double)->Double{
    return length * cellWidth
}
func addMoney(deltaMoney: Int){
    if  MoneyManager.shared.money == 9999{
        return
    }else{
        MoneyManager.shared.money = min(MoneyManager.shared.money + deltaMoney,9999)
    }
}

func getAngle(position1:(Double,Double),position2:(Double,Double)) -> Double{
    let deltaX = position1.0 - position2.0
    let deltaY = position1.1 - position2.1
    let angle = atan2(deltaY, deltaX)
    let angleInDegrees = angle * 180 / .pi
    return angleInDegrees
}
