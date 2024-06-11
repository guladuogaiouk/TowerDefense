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
func getRotateAngle(towerPostionInt:(Int,Int),enemyPosition:(Double,Double)) -> Double{
    let towerPosition: (Double,Double) = getRealPosition(position: towerPostionInt)
    return getAngle(position1: towerPosition, position2: enemyPosition)
}
func getTurnPoint(path:[(Int,Int)]) -> [(Double,Double)]{
    var turnPoint:[(Double,Double)] = []
    for i in path.indices{
        if (i == 0 || i == path.count - 1){
            turnPoint.append(getRealPosition(position: path[i]))
        }else if((path[i-1].0 != path[i+1].0) && (path[i-1].1 != path[i+1].1)){
            turnPoint.append(getRealPosition(position: path[i]))
        }
    }
    return turnPoint
}
func isEnemyInPath(enemyPostion:(Double,Double),lastTurnPointIndex: Int)->Int{
    if(lastTurnPointIndex == turnPoint.count - 1){ return -1 }
    let lastTurnPointPosition = turnPoint[lastTurnPointIndex]
    let nextTurnPointPosition = turnPoint[lastTurnPointIndex + 1]
    let enemyX = enemyPostion.0
    let enemyY = enemyPostion.1
    if(lastTurnPointPosition.0 == nextTurnPointPosition.0 && lastTurnPointPosition.1 > nextTurnPointPosition.1){ //从下向上
        if(enemyX >= lastTurnPointPosition.0 - cellWidth * 0.5 && enemyX <= lastTurnPointPosition.0 + cellWidth * 0.5){
            if(enemyY <= lastTurnPointPosition.1 && enemyY >= nextTurnPointPosition.1){
                return 1
            }
        }
    }else if(lastTurnPointPosition.0 == nextTurnPointPosition.0 && lastTurnPointPosition.1 < nextTurnPointPosition.1){ //从上向下
        if(enemyX >= lastTurnPointPosition.0 - cellWidth * 0.5 && enemyX <= lastTurnPointPosition.0 + cellWidth * 0.5){
            if(enemyY >= lastTurnPointPosition.1 && enemyY <= nextTurnPointPosition.1){
                return 2
            }
        }
    }else if(lastTurnPointPosition.1 == nextTurnPointPosition.1 && lastTurnPointPosition.0 < nextTurnPointPosition.0){ //从左到右
        if(enemyY >= lastTurnPointPosition.1 - cellWidth * 0.5 && enemyY <= lastTurnPointPosition.1 + cellWidth * 0.5){
            if(enemyX >= lastTurnPointPosition.0 && enemyX <= nextTurnPointPosition.0){
                return 3
            }
        }
    }else if(lastTurnPointPosition.1 == nextTurnPointPosition.1 && lastTurnPointPosition.0 > nextTurnPointPosition.0){ //从右到左
        if(enemyY >= lastTurnPointPosition.1 - cellWidth * 0.5 && enemyY <= lastTurnPointPosition.1 + cellWidth * 0.5){
            if(enemyX <= lastTurnPointPosition.0 && enemyX >= nextTurnPointPosition.0){
                return 4
            }
        }
    }
    return 0
}
