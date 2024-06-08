import SwiftUI
var cellWidth: Double = ScreenSize.cellScale
var cellHeight: Double = ScreenSize.cellScale

let path: [(Int, Int)] = [
    (1, 8), (2, 8), (3, 8), (4, 8), (5, 8), (6, 8), (7, 8),
    (7, 7), (7, 6), (7, 5), (7, 4), (8, 4), (9, 4),
    (9, 3), (9, 2), (10, 2), (11, 2), (12, 2), (13, 2), (14, 2), (15, 2)
]
var towerCards: [Tower] = [
    AttackerTower(name: "attacker1", hp: 100, price: 150, cd: 20, level: 1, position: (0,0)),
    AttackerTower(name: "attacker1", hp: 100, price: 50, cd: 10, level: 2, position: (0,0)),
    AttackerTower(name: "attacker1", hp: 100, price: 200, cd: 30, level: 3, position: (0,0)),
    AttackerTower(name: "attacker2", hp: 100, price: 150, cd: 20, level: 1, position: (0,0)),
    AttackerTower(name: "attacker2", hp: 100, price: 50, cd: 10, level: 2, position: (0,0)),
    AttackerTower(name: "attacker2", hp: 100, price: 200, cd: 30, level: 3, position: (0,0)),
    AttackerTower(name: "attacker3", hp: 100, price: 150, cd: 20, level: 1, position: (0,0)),
    AttackerTower(name: "attacker3", hp: 100, price: 50, cd: 10, level: 2, position: (0,0)),
    AttackerTower(name: "attacker3", hp: 100, price: 200, cd: 30, level: 3, position: (0,0)),
    AttackerTower(name: "attacker4", hp: 100, price: 150, cd: 20, level: 1, position: (0,0)),
    AttackerTower(name: "attacker4", hp: 100, price: 50, cd: 10, level: 2, position: (0,0)),
    AttackerTower(name: "attacker4", hp: 100, price: 200, cd: 30, level: 3, position: (0,0))
]
var turnPoint: [(Double,Double)] = []

class TowerCardViews: ObservableObject{
    @Published var towerCardViews: [TowerCardView] = []
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
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HeaderView(isCardClicked: $isCardClicked,selectedTower: $selectedTower,money: $money)
                    .frame(height: cellHeight * 1.0)
                ZStack{
                    GridView(isCardClicked: $isCardClicked, selectedTower: $selectedTower, money: $money, trigger: $trigger, path: path)
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
                startGame()
            }
            .frame(width: ScreenSize.width, height: ScreenSize.height)
            .simultaneousGesture(
                TapGesture().onEnded{
                    for i in trigger.indices{
                        trigger[i] = false
                    }
                }
            )
        }
    }
    
    func initVariables() {
        turnPoint = getTurnPoint(path: path)
        for i in enemyData.enemies.indices {
            enemyData.enemies[i].position = turnPoint[0]
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
    func startGame(){
        moveEnemies()
    }
    func moveEnemies() {
        for i in enemyData.enemies.indices{
            move(enemy:enemyData.enemies[i],to: 1)
        }
    }
    func move(enemy: Enemy, to turnIndex: Int) {
        guard turnIndex < turnPoint.count else { return }
        let distance = turnPoint[turnIndex - 1].0 == turnPoint[turnIndex].0 ?
        abs(turnPoint[turnIndex - 1].1 - turnPoint[turnIndex].1) :
        abs(turnPoint[turnIndex - 1].0 - turnPoint[turnIndex].0)
        let duration: Double = Double(distance) / 50 / enemy.speed
        withAnimation(.linear(duration: duration)) {
            enemy.position = turnPoint[turnIndex]
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            move(enemy: enemy, to: turnIndex + 1)
        }
        
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
