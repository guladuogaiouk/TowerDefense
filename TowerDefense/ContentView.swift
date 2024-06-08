import SwiftUI
import Combine

var cellWidth: Double = ScreenSize.cellScale
var cellHeight: Double = ScreenSize.cellScale
var timer: AnyCancellable? = nil
let path: [(Int, Int)] = [
    (1, 8), (2, 8), (3, 8), (4, 8), (5, 8), (6, 8), (7, 8),
    (7, 7), (7, 6), (7, 5), (7, 4), (8, 4), (9, 4),
    (9, 3), (9, 2), (10, 2), (11, 2), (12, 2), (13, 2), (14, 2), (15, 2)
]
var towerCards: [Tower] = [
    AttackerTower(name: "attacker1", level: 1, position: (0,0)),
    AttackerTower(name: "attacker2", level: 1, position: (0,0)),
    AttackerTower(name: "attacker3", level: 1, position: (0,0)),
    AttackerTower(name: "attacker4", level: 1, position: (0,0))
]
var turnPoint: [(Double,Double)] = []
var lastTurnPoint: [Int] = []
class EnemyTracker {
    @EnvironmentObject var enemyData: EnemyData
    var timer: DispatchSourceTimer?

    func startTimer() {
        let queue = DispatchQueue.main
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: 0.016)
        timer?.setEventHandler { [weak self] in
            self?.logEnemyPositions()
        }
        timer?.resume()
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    func logEnemyPositions() {
        print("\(enemyData.enemies[0].position)")
    }
}
class TowerCardViews: ObservableObject{
    @Published var towerCardViews: [TowerCardView] = []
}
func getRealDistance(towerPositionInt: (Int,Int), enemyPosition:(Double,Double))->Double{
    let towerPosition = getRealPosition(position: towerPositionInt)
    return sqrt(pow(enemyPosition.0-towerPosition.0, 2) + pow(enemyPosition.1-towerPosition.0, 1))
}
func getRealPosition(position: (Int, Int)) -> (Double, Double) {
    let real_x = Double(position.0) * cellWidth - cellWidth / 2
    let real_y = Double(10 - position.1) * cellHeight - cellHeight / 2
    return (real_x, real_y)
}

struct ContentView: View {
    @StateObject var enemyData = EnemyData()
    @EnvironmentObject var towerData: TowerData
    @EnvironmentObject var towerCardViews: TowerCardViews
    @EnvironmentObject var coveredCells: CoveredCells
    @State var isCardClicked: Bool = false
    @State var selectedTower: Tower? = nil
    @State var money: Int = 2000
    @State var trigger: [Bool] = []
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HeaderView(isCardClicked: $isCardClicked,selectedTower: $selectedTower,money: $money)
                    .frame(height: cellHeight * 1.0)
                ZStack{
                    GridView(isCardClicked: $isCardClicked, selectedTower: $selectedTower, money: $money, trigger: $trigger, path: path)
                    BorningPointView()
                        .position(x:getRealPosition(position: path[0]).0, y: getRealPosition(position: path[0]).1)
                    ForEach(enemyData.enemies){enemy in
                        EnemyView(enemy: enemy)
                            .position(x: enemy.position.0, y: enemy.position.1)
                    }
                    ForEach(towerData.towers.indices, id:\.self){ index in
                        let tower = towerData.towers[index]
                        let realPosition = getRealPosition(position: tower.position)
                        TowerView(tower: tower)
                            .position(x: realPosition.0,y:realPosition.1)
                            .onTapGesture{
                                trigger[index] = true
                            }
                    }
                    ForEach(towerData.towers.indices, id:\.self){ index in
                        let tower = towerData.towers[index]
                        let realPosition = getRealPosition(position: tower.position)
                        trigger[index] == true ?
                        SideButtonView(money: $money, tower: tower)
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
                //                startGame()
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
            }
        }
    }
    func moveEnemies(){
        for i in enemyData.enemies.indices {
            let enemy = enemyData.enemies[i]
            switch(isEnemyInPath(enemyPostion: enemy.position, lastTurnPointIndex: lastTurnPoint[i])){
                case 1: enemy.position.1 -= enemy.speed
                case 2: enemy.position.1 += enemy.speed
                case 3: enemy.position.0 += enemy.speed
                case 4: enemy.position.0 -= enemy.speed
                case 0: lastTurnPoint[i] += 1
                default: break;
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
        @Binding var money: Int
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
                    Text("\(money)")
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
                                        if money < tower.price {
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
        @Binding var money: Int
        @Binding var trigger: [Bool]
        var path: [(Int, Int)]
        var body: some View {
            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<15, id: \.self) { column in
                            let isPathCell = path.contains(where: { $0 == (column + 1, 9 - row) })
                            CellView(isCardClicked: $isCardClicked, selectedTower: $selectedTower, money: $money, trigger: $trigger, position: (column + 1, 9 - row), isPathCell: isPathCell)
                        }
                    }
                }
            }
        }
    }
    
    struct CellView: View {
        @Binding var isCardClicked: Bool
        @Binding var selectedTower: Tower?
        @Binding var money: Int
        @Binding var trigger: [Bool]
        @EnvironmentObject var towerData: TowerData
        @EnvironmentObject var towerCardViews: TowerCardViews
        @EnvironmentObject var coveredCells: CoveredCells
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
                money -= newTower.price
                towerData.towers.append(newTower)
                trigger.append(false)
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
