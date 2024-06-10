import Foundation
import SwiftUI

class ProducerTower: Tower {
    var isCard: Bool
    var activatedImg: String {
        return "\(self.img).activated"
    }
    @ObservedObject var moneyManager = MoneyManager.shared
    var increasedMoney: Int {
        switch self.name {
            case "producer1":
                switch level {
                    case 1: return 25
                    case 2: return 50
                    case 3: return 100
                    default: break
                }
            default: break
        }
        return 0
    }
    var produceInterval: TimeInterval {
        return 5
    }
    var timer: Timer?
    var activatedTimer: Timer?

    init(name: String, level: Int, position: (Int, Int), isCard: Bool) {
        self.isCard = isCard
        super.init(name: name, level: level, position: position)
        if !isCard {
            self.timer = Timer.scheduledTimer(withTimeInterval: produceInterval, repeats: true) { [weak self] timer in
                self?.produceMoney()
            }
            RunLoop.main.add(self.timer!, forMode: .default)
        }
    }

    private func produceMoney() {
        self.img = "\(self.name).\(self.level).activated"
        addMoney(deltaMoney: increasedMoney)
        self.activatedTimer?.invalidate()
        self.activatedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            if let self = self {
                self.img = "\(self.name).\(self.level)"
            }
        }
        RunLoop.main.add(self.activatedTimer!, forMode: .default)
    }

    override func createCopy(at position: (Int, Int)) -> ProducerTower {
        return ProducerTower(name: self.name, level: self.level, position: position, isCard: false)
    }
}
