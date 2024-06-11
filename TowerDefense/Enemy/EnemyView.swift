import SwiftUI

struct EnemyView: View {
    @ObservedObject var enemy: Enemy
    var originalHP: Int{
        return enemy.originalHp
    }
    private var width: Double {
        return enemy.radius * 2
    }
    var body: some View {
        ZStack(alignment: .bottom){
            VStack {
                HPbarView(total: originalHP, now: enemy.hp, width: width)
                    .frame(width: width)
                Image(enemy.img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            enemy.isIced ? Image("iceEffect")
                .resizable()
                .frame(width: width * 0.7,height: width/2)
                .offset(y:width/20)
            : nil
        }
        
    }
}

struct HPbarView: View {
    let total: Int
    var now: Int
    var width: Double
    var body: some View {
        if now > 0 {
            ProgressView(value: Float(now), total: Float(total))
                .progressViewStyle(HPProgressViewStyle(width: width))
                .frame(height: 4)
                .padding(.horizontal)
        }
    }
}

struct HPProgressViewStyle: ProgressViewStyle {
    var width: Double
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .frame(height: 4)
                    .foregroundColor(.gray.opacity(0.4))
                RoundedRectangle(cornerRadius: 2.5)
                    .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.black, lineWidth: 2))
                    .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * width, height: 4)
                    .foregroundColor(.pink)
            }
        }
        .frame(width: width)
    }
}
