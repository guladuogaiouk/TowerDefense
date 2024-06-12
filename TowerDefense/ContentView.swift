import SwiftUI

var cellWidth: Double = ScreenSize.cellScale
var cellHeight: Double = ScreenSize.cellScale

var turnPoint: [(Double,Double)] = []
var lastTurnPoint: [Int] = []
var attackerTimers: [Timer?] = []
var attackedRangeBullet: [UUID] = []

class TowerCardViews: ObservableObject{
    @Published var towerCardViews: [TowerCardView] = []
}

var mainTimer: Timer? = nil
var submainTimer: Timer? = nil

struct ContentView: View {
    @StateObject private var viewModel = JsonModel()
    var level: Int
    @Binding var showView: Int
    @ObservedObject var enemyData = EnemyData.shared
    @ObservedObject var towerData = TowerData.shared
    @EnvironmentObject var towerCardViews: TowerCardViews
    @ObservedObject var coveredCells = CoveredCells.shared
    @ObservedObject var moneyManager = MoneyManager.shared
    @EnvironmentObject var bulletData: BulletData
    @State var isCardClicked: Bool = false
    @State var selectedTower: Tower? = nil
    @State var trigger: [Bool] = []
    @State var enemyFinished: Bool = false
    @State var wave: Int = 0
    var timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HeaderView(showView: $showView, isCardClicked: $isCardClicked,selectedTower: $selectedTower,wave:$wave)
                    .frame(height: cellHeight * 1.0)
                ZStack{
                    GridView(isCardClicked: $isCardClicked, selectedTower: $selectedTower, trigger: $trigger, path: path)
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
                        TowerView(angle: towerData.towerRotateAngles[index], tower: tower)
                            .position(x: realPosition.0,y:realPosition.1)
                            .onTapGesture{
                                trigger[index] = true
                            }
                    }
                    ForEach(bulletData.enemyFreeBullets.indices, id:\.self){ index in
                        let freeBullet = bulletData.enemyFreeBullets[index]
                        FreeBulletView(freeBullet: freeBullet)
                            .position(x:freeBullet.initPosition.0,y:freeBullet.initPosition.1)
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
                    if !path.isEmpty {
                        BorningPointView()
                            .position(x: getRealPosition(position: path[0]).0, y: getRealPosition(position: path[0]).1)
                            .offset(y: -cellWidth / 2)
                        DestinationPointView()
                            .position(x: getRealPosition(position: path[path.count - 1]).0, y: getRealPosition(position: path[path.count - 1]).1)
                            .offset(y: -cellWidth / 2)
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
                moveEnemies()
                rotateTowers()
                moveBullets()
                rangeAttack()
                enemyAttack()
                if enemyFinished && submainTimer == nil{
                    if enemyData.enemies.isEmpty{
                        showView = 4
                    }
                }
//                print(towerData.towerRotateAngles)
            }
            .onDisappear(){
                path.removeAll()
                mainTimer?.invalidate()
                towerCards.removeAll()
                towerCardViews.towerCardViews.removeAll()
                enemyWaves.removeAll()
                moneyManager.money = 0
                turnPoint.removeAll()
                bulletData.rangeBullets.removeAll()
                bulletData.bullets.removeAll()
                bulletData.enemyFreeBullets.removeAll()
                for enemy in enemyData.enemies{
                    if let attackerEnemy = enemy as? AttackerEnemy{
                        attackerEnemy.attackTimer?.invalidate()
                    }
                }
                enemyData.enemies.removeAll()
                towerData.towers.removeAll()
                lastTurnPoint.removeAll()
                for timer in attackerTimers{
                    timer?.invalidate()
                }
                attackerTimers.removeAll()
                attackedRangeBullet.removeAll()
                coveredCells.coveredCells.removeAll()
            }
        }
    }
    func enemyAttack(){
        for i in enemyData.enemies.indices {
            let enemy = enemyData.enemies[i]
            if let bossEnemy = enemy as? BossAttackEnemy{
                if enemy.name == "boss1"{
                    if bossEnemy.attackTimer == nil {
                        bossEnemy.attackTimer = Timer.scheduledTimer(withTimeInterval: bossEnemy.attackInterval, repeats: true){ timer in
                            guard showView == 2 else {
                                timer.invalidate()
                                return
                            }
                            for angle: Int in stride(from: 0, through: 359, by: 20) {
                                let radians = Double(angle) * .pi / 180
                                let initPosition = enemy.position
                                bulletData.enemyFreeBullets.append(FreeBullet(angle: radians, initPosition: initPosition, name: enemy.name, level: enemy.level))
                            }
                        }
                    }
                }
            }
        }
    }
    func rangeAttack(){
        for i in bulletData.rangeBullets.indices{
            let rangeBullet = bulletData.rangeBullets[i]
            if(!attackedRangeBullet.contains(where: { $0 == rangeBullet.id})){
                attackedRangeBullet.append(rangeBullet.id)
                for enemy in enemyData.enemies{
                    if (getDistance(position1: rangeBullet.initPosition, position2: enemy.position) - enemy.radius <= getRealLength(length: rangeBullet.range)){
                        enemy.hp -= rangeBullet.attackValue
                    }
                }
            }
        }
    }
    func moveBullets(){
        for i in bulletData.bullets.indices.reversed(){
            moveBullet(bulletIndex: i)
        }
        for i in bulletData.enemyFreeBullets.indices.reversed(){
            moveFreeBullet(freeBulletIndex: i)
        }
    }
    func moveFreeBullet(freeBulletIndex: Int){
        let freeBullet = bulletData.enemyFreeBullets[freeBulletIndex]
        let nextPosition_x = freeBullet.initPosition.0 + freeBullet.speed * 0.016 * cos(freeBullet.angle)
        let nextPosition_y = freeBullet.initPosition.1 + freeBullet.speed * 0.016 * sin(freeBullet.angle)
        freeBullet.initPosition = (nextPosition_x,nextPosition_y)
        if(freeBullet.initPosition.0 > ScreenSize.width || freeBullet.initPosition.0 < 0 || freeBullet.initPosition.1 > ScreenSize.height || freeBullet.initPosition.1 < 0){
            bulletData.enemyFreeBullets.remove(at: freeBulletIndex)
        }
        for tower in towerData.towers {
            if(getRealDistance(towerPositionInt: tower.position, enemyPosition: freeBullet.initPosition) < tower.radius){
                tower.hp -= freeBullet.attackValue
                bulletData.enemyFreeBullets.remove(at: freeBulletIndex)
            }
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
                    enemy.isIced = true
                    enemy.isFired = false
                }else if bullet.name == "attacker2"{
                    enemy.isIced = false
                    enemy.isFired = true
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
        for i in towerData.towers.indices{
//            print(i,towerData.towers.count)
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
                                _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false){ timer in
                                    guard showView == 2 else {
                                        timer.invalidate()
                                        return
                                    }
                                    if let rangeBulletIndex = bulletData.rangeBullets.firstIndex(where: { $0.initPosition == realPosition}){
                                        bulletData.rangeBullets.remove(at: rangeBulletIndex)
                                    }
                                }
                                attackerTimers[i] = Timer.scheduledTimer(withTimeInterval: rangeAttackerTower.attackSpeed, repeats: true){ _ in
                                    let realPosition = getRealPosition(position: rangeAttackerTower.position)
                                    bulletData.rangeBullets.append(RangeBullet(initPosition: realPosition , name: rangeAttackerTower.name, level: rangeAttackerTower.level,range: rangeAttackerTower.range,attackSpeed: rangeAttackerTower.attackSpeed))
                                    _ = Timer.scheduledTimer(withTimeInterval: rangeAttackerTower.attackSpeed / 3, repeats: false){ timer in
                                        guard showView == 2 else {
                                            timer.invalidate()
                                            return
                                        }
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
                            bulletData.rangeBullets.remove(at: rangeBulletIndex)
                        }
                        attackerTimers[i]?.invalidate()
                        attackerTimers[i] = nil
                    }
                }else{
                    let range = getRealLength(length: attackerTower.range)
                    var enemyInRange = false
                    for j in getAllEnemiesOrder() {
                        let enemy = enemyData.enemies[j]
                        if getRealDistance(towerPositionInt: attackerTower.position, enemyPosition: enemy.position) - enemy.radius <= range {
                            towerData.towerRotateAngles[i] = getRotateAngle(towerPostionInt: attackerTower.position, enemyPosition: enemy.position)
                            if attackerTimers[i] == nil {
                                attackerTower.currentEnemy = enemy.id
                                attackerTimers[i] = Timer.scheduledTimer(withTimeInterval: attackerTower.attackSpeed, repeats: true) { timer in
                                    let realPosition = getRealPosition(position: attackerTower.position)
                                    guard i < towerData.towerRotateAngles.count else{
                                        timer.invalidate()
                                        return
                                    }
                                    let adjustedAngle = towerData.towerRotateAngles[i] / 180 * .pi
                                    let bulletInitPosition: (Double, Double) = (realPosition.0 - attackerTower.radius * cos(adjustedAngle), realPosition.1 - attackerTower.radius * sin(adjustedAngle))
                                    bulletData.bullets.append(Bullet(initPosition: bulletInitPosition, targetId: enemy.id, name: attackerTower.name, level: attackerTower.level))
                                }
                            } else if attackerTower.currentEnemy != enemy.id {
                                attackerTimers[i]?.invalidate()
                                attackerTimers[i] = nil
                                attackerTower.currentEnemy = enemy.id
//                                print(i,towerData.towers.count,attackerTimers.count,towerData.towerRotateAngles.count)
                                
                                attackerTimers[i] = Timer.scheduledTimer(withTimeInterval: attackerTower.attackSpeed, repeats: true) { timer in
                                    guard i < towerData.towerRotateAngles.count else{
                                        timer.invalidate()
                                        return
                                    }
                                    let adjustedAngle = towerData.towerRotateAngles[i] / 180 * .pi
                                    let realPosition = getRealPosition(position: attackerTower.position)
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
                    sameTurnPointEnemies.append((index: enemyIndex, distance: 0))
                }
                i += 1
            }
            sameTurnPointEnemies.sort { $0.distance < $1.distance }
            enemyOrder.append(contentsOf: sameTurnPointEnemies.map { $0.index })
        }
        return enemyOrder
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
                    if let attackEnemy = enemy as? AttackerEnemy{
                        attackEnemy.attackTimer?.invalidate()
                        attackEnemy.attackTimer = nil
                    }
                    enemyData.enemies.remove(at: i)
                    lastTurnPoint.remove(at: i)
                    showView = 3
            }
        }
    }
    
    func initVariables() {
        path = viewModel.levelItems[level].path
        towerCards = produceTowerCards(jsonTowers: viewModel.levelItems[level].towers) 
        enemyWaves = produceEnemies(jsonEnemies: viewModel.levelItems[level].enemies)
        moneyManager.money = viewModel.levelItems[level].original_money
        turnPoint = getTurnPoint(path: path)
        mainTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true){ timer in
            guard wave < enemyWaves.count && showView == 2 else {
                timer.invalidate()
                return
            }
            var index = 0
            wave += 1
            let enemies = enemyWaves[wave-1].enemies
            submainTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                guard index < enemies.count && showView == 2 else {
                    timer.invalidate()
                    submainTimer = nil
                    return
                }
                enemyData.enemies.append(enemies[index])
                enemyData.enemies[enemyData.enemies.count - 1].position = turnPoint[0]
                lastTurnPoint.append(0)
                index += 1
            }
            if wave == enemyWaves.count{
                enemyFinished = true
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

    struct HeaderView: View {
        @Binding var showView: Int
        @Binding var isCardClicked: Bool
        @Binding var selectedTower: Tower?
        @Binding var wave: Int
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
            HStack() {
                VStack(spacing:10){
                    HStack {
                        Image(systemName: "cross.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("\(moneyManager.money)")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    Text("WAVE \(wave) / \(enemyWaves.count)")
                        .foregroundColor(.gray)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
                .frame(alignment: .leading)
                HStack{
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: cellWidth * 0.4,height: cellWidth * 0.4)
                    Text("REPLAY")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .foregroundColor(Color.gray)
                .frame(height: cellWidth)
                .onTapGesture {
                    showView = 5
                }
                .frame(maxWidth: .infinity,alignment: .center)
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
        var path: [(Int, Int)]
        var body: some View {
            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<15, id: \.self) { column in
                            let isPathCell = path.contains(where: { $0 == (column + 1, 9 - row) })
                            CellView(isCardClicked: $isCardClicked, selectedTower: $selectedTower, trigger: $trigger, position: (column + 1, 9 - row), isPathCell: isPathCell)
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
        @ObservedObject var towerData = TowerData.shared
        @EnvironmentObject var towerCardViews: TowerCardViews
        @ObservedObject var coveredCells = CoveredCells.shared
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
                towerData.towerRotateAngles.append(0)
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
