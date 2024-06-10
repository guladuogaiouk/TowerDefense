import Foundation

class AttackerTower: Tower {
    var currentEnemy: UUID? = nil
    var range: Double = 2
    var attackSpeed: Double = 0.3
    
    override init(name: String, level: Int, position: (Int, Int)) {
        super.init(name: name, level: level, position: position)
        updateAttributes()
    }
    
    override func createCopy(at position: (Int, Int)) -> AttackerTower {
        return AttackerTower(name: self.name, level: self.level, position: position)
    }
    
    private func updateAttributes() {
        switch(name) {
            case "attacker1","attacker2":
                switch(level) {
                    case 1:
                        self.range = 2
                        self.attackSpeed = 0.3
                    case 2:
                        self.range = 3
                        self.attackSpeed = 0.2
                    case 3:
                        self.range = 4
                        self.attackSpeed = 0.15
                    default:
                        break
                }
            
            default:
                break
        }
    }
    
    override var level: Int {
        didSet {
            updateAttributes()
        }
    }
}
