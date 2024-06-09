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
    AttackerTower(name: "attacker4", level: 1, position: (0,0)),
    ProducerTower(name: "producer1", level: 1, position: (0,0),isCard: true)
]
var turnPoint: [(Double,Double)] = []
var lastTurnPoint: [Int] = []

class TowerCardViews: ObservableObject{
    @Published var towerCardViews: [TowerCardView] = []
}
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
func getRealLength(length: Int)->Double{
    return Double(length) * cellWidth
}

struct ContentView: View {
    @StateObject var enemyData = EnemyData()
    @EnvironmentObject var towerData: TowerData
    @EnvironmentObject var towerCardViews: TowerCardViews
    @EnvironmentObject var coveredCells: CoveredCells
    @ObservedObject var moneyManager = MoneyManager.shared
    @State var isCardClicked: Bool = false
    @State var selectedTower: Tower? = nil
    @State var trigger: [Bool] = []
    @State var towerRotateAngles: [Double] = []
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
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
                    ForEach(towerData.towers.indices, id:\.self){ index in
                        let tower = towerData.towers[index]
                        let realPosition = getRealPosition(position: tower.position)
                        TowerView(angle: $towerRotateAngles[index], tower: tower)
                            .position(x: realPosition.0,y:realPosition.1)
                            .onTapGesture{
                                trigger[index] = true
                            }
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
                moveEnemies()
                rotateTowers()
            }
        }
    }
    func rotateTowers(){
        for i in towerData.towers.indices{
            let tower = towerData.towers[i]
            if let attackerTower = tower as? AttackerTower {
                let range = getRealLength(length: attackerTower.range) + 2
                for j in getAllEnemiesOrder() {
                    let enemy = enemyData.enemies[j]
                    if getRealDistance(towerPositionInt: attackerTower.position, enemyPosition: enemy.position) <= range{
                        towerRotateAngles[i] = getRotateAngle(towerPostionInt: attackerTower.position, enemyPosition: enemy.position)
                        break
                    }
                }
            }
//            if let producerTower = tower as? ProducerTower{
//                
//            }
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

    func getDistance(position1: (Double, Double), position2: (Double, Double)) -> Double {
        return sqrt(pow(position1.0 - position2.0, 2) + pow(position1.1 - position2.1, 2))
    }

    func getRotateAngle(towerPostionInt:(Int,Int),enemyPosition:(Double,Double)) -> Double{
        let towerPosition: (Double,Double) = getRealPosition(position: towerPostionInt)
        let deltaX = towerPosition.0 - enemyPosition.0
        let deltaY = towerPosition.1 - enemyPosition.1
        let angle = atan2(deltaY, deltaX)
        let angleInDegrees = angle * 180 / .pi
        return angleInDegrees
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
        for i in enemyData.enemies.indices {
            enemyData.enemies[i].position = turnPoint[0]
            lastTurnPoint.append(0)
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
        @EnvironmentObject var moneyManager: MoneyManager
        @EnvironmentObject var towerCardViews: TowerCardViews
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
