import SwiftUI

struct EnemyView: View {
    var enemy: Enemy
    var originalHP: Int {
        return enemy.hp
    }
//    var originalHP = 200
    private var width: Double {
        return enemy.name.starts(with: "shield") ? ScreenSize.cellScale * 0.7 : ScreenSize.cellScale * 1.1
    }
    
    var body: some View {
        VStack {
            HPbarView(total: originalHP, now: enemy.hp, width: width)
                .frame(width: width)
            Image(enemy.img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct HPbarView: View {
    let total: Int
    var now: Int
    var width: Double
    var body: some View {
        ProgressView(value: Float(now), total: Float(total))
            .progressViewStyle(HPProgressViewStyle(width: width))
            .frame(height: 4)
            .padding(.horizontal)
    }
}

struct HPProgressViewStyle: ProgressViewStyle {
    var width: Double
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .frame(height: 4)
                    .foregroundColor(.gray.opacity(0.3))
                RoundedRectangle(cornerRadius: 2.5)
                    .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.black, lineWidth: 2))
                    .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * width, height: 4)
                    .foregroundColor(.red)
            }
        }
        .frame(width: width)
    }
}
