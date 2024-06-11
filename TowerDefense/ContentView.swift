import SwiftUI

var cellWidth: Double = ScreenSize.cellScale
var cellHeight: Double = ScreenSize.cellScale
let path: [(Int, Int)] = [
    (1, 8), (2, 8), (3, 8), (4, 8), (5, 8), (6, 8), (7, 8),
    (7, 7), (7, 6), (7, 5), (7, 4), (8, 4), (9, 4),
    (9, 3), (9, 2), (10, 2), (11, 2), (12, 2), (13, 2), (14, 2), (15, 2)
]
var towerCards: [Tower] = [
    AttackerTower(name: "attacker1", level: 1, position: (0,0)),
    AttackerTower(name: "attacker2", level: 1, position: (0,0)),
    AttackerTower(name: "attacker3", level: 1, position: (0,0)),
    RangeAttackerTower(name: "attacker4", level: 1, position: (0,0)),
    ProducerTower(name: "producer1", level: 1, position: (0,0),isCard: true)
]
var turnPoint: [(Double,Double)] = []
var lastTurnPoint: [Int] = []
var attackerTimers: [Timer?] = []
var attackedRangeBullet: [UUID] = []

class TowerCardViews: ObservableObject{
    @Published var towerCardViews: [TowerCardView] = []
}


struct ContentView: View {
    @StateObject var enemyData = EnemyData()
    @EnvironmentObject var towerData: TowerData
    @EnvironmentObject var towerCardViews: TowerCardViews
    @EnvironmentObject var coveredCells: CoveredCells
    @ObservedObject var moneyManager = MoneyManager.shared
    @EnvironmentObject var bulletData: BulletData
    @State var isCardClicked: Bool = false
    @State var selectedTower: Tower? = nil
    @State var trigger: [Bool] = []
    @State var towerRotateAngles: [Double] = []
    var timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HeaderView(isCardClicked: $isCardClicked,selectedTower: $selectedTower)
                    .frame(height: cellHeight * 1.0)
                ZStack{
                    GridView(isCardClicked: $isCardClicked, selectedTower: $selectedTower, trigger: $trigger, towerRotateAngles: $towerRotateAngles, path: path)
                    BorningPointView()
                        .position(x:getRealPosition(position: path[0]).0, y: getRealPosition(position: path[0]).1)
                    ForEach(enemyData.enemies){enemy in
                        EnemyView(enemy: enemy)
                            .position(x: enemy.position.0, y: enemy.position.1)
                    }
                    ForEach(bulletData.rangeBullets.indices, id:\.self){ index in
                        let rangeBullet = bulletData.rangeBullets[index]
                        RangeBulletView(rangeBullet: rangeBullet)
                            .position(x:rangeBullet.initPosition.0,y:rangeBullet.initPosition.1)
                    }
                    ForEach(towerData.towers.indices, id:\.self){ index in
                        let tower = towerData.towers[index]
                        let realPosition = getRealPosition(position: tower.position)
                        TowerView(angle: $towerRotateAngles[index], tower: tower)
                            .position(x: realPosition.0,y:realPosition.1)
                            .onTapGesture{
                                trigger[index] = true
                            }
                    }
                    ForEach(bulletData.bullets.indices, id:\.self){ index in
                        let bullet = bulletData.bullets[index]
                        BulletView(bullet: bullet)
                            .position(x:bullet.initPosition.0,y:bullet.initPosition.1)
                    }
                    ForEach(towerData.towers.indices, id:\.self){ index in
                        let tower = towerData.towers[index]
                        let realPosition = getRealPosition(position: tower.position)
                        trigger[index] == true ?
                        SideButtonView(tower: tower)
                            .position(x: realPosition.0,y:realPosition.1)
                        : nil
                    }
                    
                }
                .frame(height: cellHeight * 9.0)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity)
            .background(Color(red: 242/255, green: 242/255, blue: 242/255))
            .onAppear {
                initVariables()
            }
            .frame(width: ScreenSize.width, height: ScreenSize.height)
            .simultaneousGesture(
                TapGesture().onEnded{
                    for i in trigger.indices{
                        trigger[i] = false
                    }
                }
            )
            .onReceive(timer) { _ in
//                print("1")
                moveEnemies()
                rotateTowers()
                moveBullets()
                rangeAttack()
            }
        }
    }
    func rangeAttack(){
        for i in bulletData.rangeBullets.indices{
            let rangeBullet = bulletData.rangeBullets[i]
            if(!attackedRangeBullet.contains(where: { $0 == rangeBullet.id})){
//                print("1")
                attackedRangeBullet.append(rangeBullet.id)
                for enemy in enemyData.enemies{
                    if (getDistance(position1: rangeBullet.initPosition, position2: enemy.position) - enemy.radius <= getRealLength(length: rangeBullet.range)){
                        enemy.hp -= rangeBullet.attackValue
                        if enemy.hp <= 0 {
                            if let index = enemyData.enemies.firstIndex(of: enemy){
                                enemyData.enemies.remove(at: index)
                                lastTurnPoint.remove(at: index)
                            }
                        }
                    }
                }
            }
        }
    }
    func moveBullets(){
        for i in bulletData.bullets.indices.reversed(){
            moveBullet(bulletIndex: i)
        }
    }
    func moveBullet(bulletIndex: Int){
        let bullet = bulletData.bullets[bulletIndex]
        if let enemy = enemyData.enemies.first(where: { $0.id == bullet.targetId }) {
            bullet.angle = getAngle(position1: bullet.initPosition, position2: enemy.position) / 180 * .pi
            if(getDistance(position1: bullet.initPosition, position2: enemy.position) <= enemy.radius){
                bulletData.bullets.remove(at: bulletIndex)
                enemy.hp -= bullet.attackValue
                if bullet.name == "attacker3"{
//                    print("iced")
//                    enemy
                    enemy.isIced = true
                }
                if(enemy.hp <= 0){
                    if let index = enemyData.enemies.firstIndex(of: enemy){
                        enemyData.enemies.remove(at: index)
                        lastTurnPoint.remove(at: index)
                    }
                }
            }
                let delta_X = bullet.flySpeed * 0.016 * cos(bullet.angle)
                let delta_Y = bullet.flySpeed * 0.016 * sin(bullet.angle)
                bullet.initPosition = (bullet.initPosition.0 - delta_X, bullet.initPosition.1 - delta_Y)
            }else{
                bulletData.bullets.remove(at: bulletIndex)
            }
        if(bullet.initPosition.0 > ScreenSize.width || bullet.initPosition.0 < 0 || bullet.initPosition.1 > ScreenSize.height || bullet.initPosition.1 < 0){
            bulletData.bullets.remove(at: bulletIndex)
        }
    }
    func rotateTowers() {
        for i in towerData.towers.indices {
            let tower = towerData.towers[i]
            if let attackerTower = tower as? AttackerTower {
                if let rangeAttackerTower = attackerTower as? RangeAttackerTower{
                    var isEnemyInRange = false
                    for j in enemyData.enemies.indices{
                        let enemy = enemyData.enemies[j]
                        if(getDistance(position1: enemy.position, position2: getRealPosition(position: rangeAttackerTower.position) ) - enemy.radius <= getRealLength(length: rangeAttackerTower.range)){
                            isEnemyInRange = true
                            if attackerTimers[i] == nil{
                                let realPosition = getRealPosition(position: rangeAttackerTower.position)
                                bulletData.rangeBullets.append(RangeBullet(initPosition: realPosition , name: rangeAttackerTower.name, level: rangeAttackerTower.level,range: rangeAttackerTower.range,attackSpeed: rangeAttackerTower.attackSpeed))
                                _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false){ _ in
                                    if let rangeBulletIndex = bulletData.rangeBullets.firstIndex(where: { $0.initPosition == realPosition}){
                                        bulletData.rangeBullets.remove(at: rangeBulletIndex)
                                    }
                                }
                                attackerTimers[i] = Timer.scheduledTimer(withTimeInterval: rangeAttackerTower.attackSpeed, repeats: true){ _ in
                                    let realPosition = getRealPosition(position: rangeAttackerTower.position)
                                    bulletData.rangeBullets.append(RangeBullet(initPosition: realPosition , name: rangeAttackerTower.name, level: rangeAttackerTower.level,range: rangeAttackerTower.range,attackSpeed: rangeAttackerTower.attackSpeed))
                                    _ = Timer.scheduledTimer(withTimeInterval: rangeAttackerTower.attackSpeed / 3, repeats: false){ _ in
                                        if let rangeBulletIndex = bulletData.rangeBullets.firstIndex(where: { $0.initPosition == realPosition}){
                                            if let bulletIdIndex = attackedRangeBullet.firstIndex(where: { $0 == bulletData.rangeBullets[rangeBulletIndex].id}){
                                                attackedRangeBullet.remove(at: bulletIdIndex)
                                            }
                                            bulletData.rangeBullets.remove(at: rangeBulletIndex)
                                        }
                                    }
                                }
                            }
                            break
                        }
                    }
                    if !isEnemyInRange{
                        let realPosition = getRealPosition(position: rangeAttackerTower.position)
                        if let rangeBulletIndex = bulletData.rangeBullets.firstIndex(where: { $0.initPosition == realPosition}){
                            print("here")
                            bulletData.rangeBullets.remove(at: rangeBulletIndex)
                        }
                        attackerTimers[i]?.invalidate()
                        attackerTimers[i] = nil
                    }
                }else{
                    let range = getRealLength(length: attackerTower.range) + 2
                    var enemyInRange = false
                    for j in getAllEnemiesOrder() {
                        let enemy = enemyData.enemies[j]
                        if getRealDistance(towerPositionInt: attackerTower.position, enemyPosition: enemy.position) - enemy.radius <= range {
                            towerRotateAngles[i] = getRotateAngle(towerPostionInt: attackerTower.position, enemyPosition: enemy.position)
                            if attackerTimers[i] == nil {
                                attackerTower.currentEnemy = enemy.id
                                attackerTimers[i] = Timer.scheduledTimer(withTimeInterval: attackerTower.attackSpeed, repeats: true) { _ in
                                    let realPosition = getRealPosition(position: attackerTower.position)
                                    let adjustedAngle = towerRotateAngles[i] / 180 * .pi
                                    let bulletInitPosition: (Double, Double) = (realPosition.0 - attackerTower.radius * cos(adjustedAngle), realPosition.1 - attackerTower.radius * sin(adjustedAngle))
                                    bulletData.bullets.append(Bullet(initPosition: bulletInitPosition, targetId: enemy.id, name: attackerTower.name, level: attackerTower.level))
                                }
                            } else if attackerTower.currentEnemy != enemy.id {
                                attackerTimers[i]?.invalidate()
                                attackerTimers[i] = nil
                                attackerTower.currentEnemy = enemy.id
                                attackerTimers[i] = Timer.scheduledTimer(withTimeInterval: attackerTower.attackSpeed, repeats: true) { _ in
                                    let realPosition = getRealPosition(position: attackerTower.position)
                                    let adjustedAngle = towerRotateAngles[i] / 180 * .pi
                                    let bulletInitPosition: (Double, Double) = (realPosition.0 - attackerTower.radius * cos(adjustedAngle), realPosition.1 - attackerTower.radius * sin(adjustedAngle))
                                    bulletData.bullets.append(Bullet(initPosition: bulletInitPosition, targetId: enemy.id, name: attackerTower.name, level: attackerTower.level))
                                }
                            }
                            enemyInRange = true
                            break
                        }
                    }
                    if !enemyInRange {
                        attackerTimers[i]?.invalidate()
                        attackerTimers[i] = nil
                        attackerTower.currentEnemy = nil
                    }
                }
            }
        }
    }


    func getAllEnemiesOrder() -> [Int] {
        var enemyOrder: [Int] = []
        var indexedEnemies: [(index: Int, turnPoint: Int)] = []
        for i in lastTurnPoint.indices {
            indexedEnemies.append((index: i, turnPoint: lastTurnPoint[i]))
        }
        indexedEnemies.sort { $0.turnPoint > $1.turnPoint }
        var i = 0
        while i < indexedEnemies.count {
            let currentTurnPoint = indexedEnemies[i].turnPoint
            var sameTurnPointEnemies: [(index: Int, distance: Double)] = []
            while i < indexedEnemies.count && indexedEnemies[i].turnPoint == currentTurnPoint {
                let enemyIndex = indexedEnemies[i].index
                if currentTurnPoint < turnPoint.count - 1 {
                    let distance = getDistance(position1: turnPoint[currentTurnPoint + 1], position2: enemyData.enemies[enemyIndex].position)
                    sameTurnPointEnemies.append((index: enemyIndex, distance: distance))
                } else {
                    sameTurnPointEnemies.append((index: enemyIndex, distance: 0)) // 对于最后一个 turnPoint，距离设为 0
                }
                i += 1
            }
            sameTurnPointEnemies.sort { $0.distance < $1.distance }
            enemyOrder.append(contentsOf: sameTurnPointEnemies.map { $0.index })
        }
        return enemyOrder
    }

    
    func getRotateAngle(towerPostionInt:(Int,Int),enemyPosition:(Double,Double)) -> Double{
        let towerPosition: (Double,Double) = getRealPosition(position: towerPostionInt)
        return getAngle(position1: towerPosition, position2: enemyPosition)
    }
    func moveEnemies(){
        for i in enemyData.enemies.indices.reversed() {
            let enemy = enemyData.enemies[i]
            switch(isEnemyInPath(enemyPostion: enemy.position, lastTurnPointIndex: lastTurnPoint[i])) {
                case 1:
                    enemy.position.1 -= enemy.speed
                case 2:
                    enemy.position.1 += enemy.speed
                case 3:
                    enemy.position.0 += enemy.speed
                case 4:
                    enemy.position.0 -= enemy.speed
                case 0:
                    lastTurnPoint[i] += 1
                default:
                    enemyData.enemies.remove(at: i)
                    lastTurnPoint.remove(at: i)
            }
        }
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
    func initVariables() {
        turnPoint = getTurnPoint(path: path)
        var index = 0
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if index < enemies.count {
                enemyData.enemies.append(enemies[index])
                enemyData.enemies[enemyData.enemies.count - 1].position = turnPoint[0]
                lastTurnPoint.append(0)
                index += 1
            }
        }
        for i in towerData.towers.indices {
            towerData.towers[i].position = (towerData.towers[i].position.0, towerData.towers[i].position.1)
        }
        for i in path.indices {
            coveredCells.coveredCells.append(path[i])
        }
        for tower in towerCards {
            let viewModel = TowerCardViewModel(tower: tower)
            let towerCardView = TowerCardView(viewModel: viewModel)
            viewModel.startWaiting()
            towerCardViews.towerCardViews.append(towerCardView)
        }
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

    struct HeaderView: View {
        @Binding var isCardClicked: Bool
        @Binding var selectedTower: Tower?
        @EnvironmentObject var towerCardViews: TowerCardViews
        @ObservedObject var moneyManager = MoneyManager.shared
        func clickTowerCard(tower: Tower){
            if selectedTower != nil{
                if selectedTower == tower{
                    isCardClicked.toggle()
                }else{
                    selectedTower = tower
                    isCardClicked = true
                }
            }else{
                isCardClicked = true
                selectedTower = tower
            }
        }
        var body: some View {
            HStack {
                HStack {
                    Image(systemName: "cross.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("\(moneyManager.money)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .foregroundColor(Color(red: 112/255, green: 173/255, blue: 71/255))
                .frame(width: 140, height: 90, alignment: .center)
                .padding(10)
                .frame(maxHeight: .infinity)
                
                HStack {
                    ForEach(0..<12, id: \.self) { index in
                        if index < towerCardViews.towerCardViews.count{
                            let towerCardView = towerCardViews.towerCardViews[index]
                            let tower = towerCardView.viewModel.tower
                            towerCardView
                                .background(Color(red: 190/255, green: 190/255, blue: 190/255))
                                .overlay(
                                    Group {
                                        if isCardClicked && selectedTower == tower {
                                            Rectangle()
                                                .stroke(Color.yellow.opacity(0.5), lineWidth: 5)
                                        }
                                    }
                                )
                                .onTapGesture {
                                    if(!towerCardView.viewModel.isCoolingDown){
                                        clickTowerCard(tower: tower)
                                    }
                                }
                                .overlay(
                                    Group {
                                        if moneyManager.money < tower.price {
                                            Rectangle()
                                                .fill(Color.black.opacity(0.6))
                                                .frame(width: cellWidth * 0.8, height: cellHeight * 1.0)
                                        }
                                    }
                                )
                        }else{
                            Rectangle()
                                .fill(Color(red: 242/255, green: 242/255, blue: 242/255))
                                .frame(width: cellWidth * 0.8, height: cellHeight * 1.0)
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 30)
            .frame(maxHeight: .infinity)
            .background(Color(red: 217/255, green: 217/255, blue: 217/255))
        }
    }
    
    struct GridView: View {
        @Binding var isCardClicked: Bool
        @Binding var selectedTower: Tower?
        @Binding var trigger: [Bool]
        @Binding var towerRotateAngles: [Double]
        var path: [(Int, Int)]
        var body: some View {
            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<15, id: \.self) { column in
                            let isPathCell = path.contains(where: { $0 == (column + 1, 9 - row) })
                            CellView(isCardClicked: $isCardClicked, selectedTower: $selectedTower, trigger: $trigger, towerRotateAngles: $towerRotateAngles, position: (column + 1, 9 - row), isPathCell: isPathCell)
                        }
                    }
                }
            }
        }
    }
    
    struct CellView: View {
        @Binding var isCardClicked: Bool
        @Binding var selectedTower: Tower?
        @Binding var trigger: [Bool]
        @Binding var towerRotateAngles: [Double]
        @EnvironmentObject var towerData: TowerData
        @EnvironmentObject var towerCardViews: TowerCardViews
        @EnvironmentObject var coveredCells: CoveredCells
        @EnvironmentObject var moneyManager: MoneyManager
        var position: (Int,Int)
        var isPathCell: Bool
        var body: some View {
            Rectangle()
                .fill(isPathCell ? Color.white :
                        !isCardClicked ? Color(red: 242/255, green: 242/255, blue: 242/255)
                      : coveredCells.coveredCells.contains(where: { $0 == position}) ? Color(red: 242/255, green: 242/255, blue: 242/255)
                      : Color(red: 150/255, green: 150/255, blue: 150/255))
                .frame(width: cellWidth * 1.0, height: cellHeight * 1.0)
                .overlay(
                    isPathCell ? nil : Rectangle()
                        .stroke(Color(red: 217/255, green: 217/255, blue: 217/255), lineWidth: 1)
                )
                .onTapGesture {
                    if(isCardClicked && !coveredCells.coveredCells.contains(where: { $0 == position})){
                        layoutTower()
                    }
                }
        }
        func layoutTower(){
            if let selectedTower = selectedTower {
                let newTower = selectedTower.createCopy(at: position)
                moneyManager.money -= newTower.price
                towerData.towers.append(newTower)
                trigger.append(false)
                towerRotateAngles.append(-90)
                coveredCells.coveredCells.append(position)
                attackerTimers.append(nil)
                isCardClicked = false
                for towercard in towerCardViews.towerCardViews{
                    if(towercard.viewModel.tower == selectedTower){
                        towercard.viewModel.startWaiting()
                    }
                }
            }
        }
    }
}
