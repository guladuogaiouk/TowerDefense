//
//  Factory.swift
//  TowerDefense
//
//  Created by Tianyu Xu on 2024/6/12.
//

import Foundation
func produceTowerCards(jsonTowers: [ItemJson]) -> [Tower]{
    var towercards: [Tower] = []
    for i in jsonTowers.indices{
        let itemJson = jsonTowers[i]
        switch itemJson.type{
            case "AttackerTower": towercards.append(AttackerTower(name: itemJson.name, level: 1, position: (0,0)))
            case "RangeAttackerTower": towercards.append(RangeAttackerTower(name: itemJson.name, level: 1, position: (0,0)))
            case "ProducerTower": towercards.append(ProducerTower(name: itemJson.name, level: 1, position: (0,0), isCard: true))
            default: break
        }
    }
    return towercards
}

func produceEnemies(jsonEnemies: [EnemyWaveJson]) -> [EnemyWave]{
    var enemyWaves: [EnemyWave] = []
    for i in jsonEnemies.indices{
        let enemyWaveJson = jsonEnemies[i]
        var enemies: [Enemy] = []
        for j in enemyWaveJson.enemies.indices{
            let enemy = enemyWaveJson.enemies[j]
            switch enemy.type{
                case "AttackerEnemy": enemies.append(AttackerEnemy(name: enemy.name, level: 1))
                case "BossAttackerEnemy": enemies.append(BossAttackEnemy(name: enemy.name, level: 1))
                default: break
            }
        }
        enemyWaves.append(EnemyWave(wave: i + 1, enemies: enemies))
    }
    return enemyWaves
}
