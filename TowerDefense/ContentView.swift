
import SwiftUI

struct ContentView: View {
    let path: [(Int, Int)] = [
        (1, 8), (2, 8), (3, 8), (4, 8), (5, 8), (6, 8), (7, 8),
        (7, 7), (7, 6), (7, 5), (7, 4), (8, 4), (9, 4),
        (9, 3), (9, 2), (10, 2), (11, 2), (12, 2), (13, 2), (14, 2), (15, 2)
    ]
    @State var cellWidth: Double = 0
    @State var cellHeight: Double = 0
    @State var turnPoint: [(Double,Double)] = []
    @State var enemies: [Enemy] = [
        Enemy(name: "XTY1", speed: 1, hp: 100, value: 25, position: (0, 0),img: "shield1"),
        AttackerEnemy(name: "XTY2", speed: 1.5, hp: 100, value: 25, position: (0, 0),img: "shield2" ,attack: 5,range: 5),
        Enemy(name: "XTY3", speed: 0.8, hp: 100, value: 25, position: (0, 0),img: "shield3"),
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HeaderView(geometry: geometry)
                    .frame(height: geometry.size.height * 0.1)
                ZStack{
                    GridView(geometry: geometry, path: path)
                    ForEach(enemies){enemy in
                        EnemyView(img: enemy.img)
                            .position(x: enemy.position.0, y: enemy.position.1)
                    }
                }
            }
            .onAppear {
                cellWidth = geometry.size.width / 15
                cellHeight = geometry.size.height * 0.9 / 9
                turnPoint = getTurnPoint(path: path)
                for i in enemies.indices{
                    enemies[i].position = turnPoint[0]
                }

                startGame()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    func getTurnPoint(path:[(Int,Int)]) -> [(Double,Double)]{
        var turnPoint:[(Double,Double)] = []
        for i in path.indices{
            if (i == 0 || i == path.count - 1){
                turnPoint.append(getRealPosition(position: path[i], cellHeight: cellHeight, cellWidth: cellWidth))
            }else if((path[i-1].0 != path[i+1].0) && (path[i-1].1 != path[i+1].1)){
                turnPoint.append(getRealPosition(position: path[i], cellHeight: cellHeight, cellWidth: cellWidth))
            }
        }
        return turnPoint
    }
    
    func getRealPosition(position: (Int, Int), cellHeight: Double, cellWidth: Double) -> (Double, Double) {
        let real_x = Double(position.0) * cellWidth - cellWidth / 2
        let real_y = Double(10 - position.1) * cellHeight - cellHeight / 2
        return (real_x, real_y)
    }
    
    func startGame(){
        moveEnemies()
    }
    func moveEnemies() {
        for i in enemies.indices{
            move(enemy:enemies[i],to: 1)
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
}

struct HeaderView: View {
    var geometry: GeometryProxy
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "cross.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text("500")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .foregroundColor(Color(red: 112/255, green: 173/255, blue: 71/255))
            .frame(width: 140, height: 90, alignment: .center)
            .padding(10)
            .frame(maxHeight: .infinity)

            HStack {
                ForEach(0..<12, id: \.self) { index in
                    Rectangle()
                        .fill(Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: geometry.size.width / 20, height: geometry.size.height * 0.094)
                        .border(Color(red: 166/255, green: 166/255, blue: 166/255))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 20)
        .frame(maxHeight: .infinity)
        .background(Color(red: 217/255, green: 217/255, blue: 217/255))
    }
}

struct GridView: View {
    var geometry: GeometryProxy
    var path: [(Int, Int)]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<9, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<15, id: \.self) { column in
                        let isPathCell = path.contains(where: { $0 == (column + 1, 9 - row) })
                        CellView(isPathCell: isPathCell, geometry: geometry)
                    }
                }
            }
        }
    }
}

struct CellView: View {
    var isPathCell: Bool
    var geometry: GeometryProxy
    var body: some View {
        Rectangle()
            .fill(isPathCell ? Color.white : Color(red: 242/255, green: 242/255, blue: 242/255))
            .frame(width: geometry.size.width / 15, height: (geometry.size.height * 0.9) / 9)
            .overlay(
                isPathCell ? nil : Rectangle()
                    .stroke(Color(red: 217/255, green: 217/255, blue: 217/255), lineWidth: 1)
            )
    }
}
#Preview {
    ContentView()
}


