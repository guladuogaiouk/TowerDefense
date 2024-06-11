import Foundation

@Observable
class Tower: Identifiable, Equatable {
    static func == (lhs: Tower, rhs: Tower) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID
    var name: String
    var radius: Double = cellWidth * 0.45
    var originalHp: Int = 100
    var hp: Int = 100 {
        didSet{
            if hp <= 0 {
                attackerTimers[TowerData.shared.towers.firstIndex(of: self)!]?.invalidate()
                attackerTimers.remove(at: TowerData.shared.towers.firstIndex(of: self)!)
                TowerData.shared.towers.remove(at:TowerData.shared.towers.firstIndex(of: self)!)
                if let index = CoveredCells.shared.coveredCells.firstIndex(where: { $0 == self.position }) {
                    CoveredCells.shared.coveredCells.remove(at: index)
                }
            }
        }
    }
    var price: Int = 100
    var cd: Int = 10
    var level: Int {
        didSet {
            img = "\(name).\(level)"
            switch name {
                case "attacker1": self.costToNextLevel = 100
                case "attacker2": self.costToNextLevel = 150
                case "attacker3": self.costToNextLevel = 150
                case "attacker4": self.costToNextLevel = 200
                case "producer1": self.costToNextLevel = 125
                default: break;
            }
        }
    }
    var costToNextLevel: Int = 100
    var position: (Int, Int)
    var img: String
    
    init(name: String, level: Int, position: (Int, Int)) {
        self.id = UUID()
        self.name = name
        self.level = level
        self.position = position
        self.img = "\(name).\(level)"
        switch name {
            case "attacker1":
                self.price = 50
                self.cd = 5
                self.costToNextLevel = 50
            case "attacker2":
                self.price = 150
                self.cd = 10
                self.costToNextLevel = 100
            case "attacker3":
                self.price = 125
                self.cd = 15
                self.costToNextLevel = 100
            case "attacker4":
                self.price = 125
                self.cd = 10
                self.costToNextLevel = 75
            case "producer1":
                self.price = 50
                self.cd = 5
                self.costToNextLevel = 50
                self.radius = cellWidth * 0.4
            default: break
        }
    }
    
    func createCopy(at position: (Int, Int)) -> Tower {
        return Tower(name: self.name, level: self.level, position: position)
    }
}
