import SwiftUI

struct ContentView: View {
    let path: [(Int, Int)] = [
        (1, 8), (2, 8), (3, 8), (4, 8), (5, 8), (6, 8), (7, 8),
        (7, 7), (7, 6), (7, 5), (7, 4), (7, 3), (7, 2),
        (8, 2), (9, 2), (10, 2), (11, 2), (12, 2), (13, 2), (14, 2), (15, 2)
    ]

    @State var enemies = [
        Enemies(name: "XTY1", speed: 1, hp: 100, value: 25, position: (1,8)),
        Enemies(name: "XTY2", speed: 1.5, hp: 100, value: 25, position: (1,8))
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HeaderView(geometry: geometry)
                    .frame(height: geometry.size.height * 0.1)
                GridView(geometry: geometry, path: path)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
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
//            .padding(.bottom, 10)
            .frame(maxHeight: .infinity)

            HStack {
                ForEach(0..<12, id: \.self) { index in
                    Rectangle()
                        .fill(Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(width: geometry.size.width / 20,height: geometry.size.height * 0.094)
//                        .frame(maxHeight: .infinity)
                        .border(Color(red: 166/255, green: 166/255, blue: 166/255))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom,20)
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
