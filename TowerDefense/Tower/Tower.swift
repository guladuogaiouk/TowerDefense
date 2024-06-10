import Foundation

@Observable
class Tower: Identifiable, Equatable {
    static func == (lhs: Tower, rhs: Tower) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID
    var name: String
    var radius: Double{
        return cellWidth * 0.45
    }
    var hp: Int {
        return 100
    }
    var price: Int {
        return 100
    }
    var cd: Int {
        return 10
    }
    var level: Int {
        didSet {
            img = "\(name).\(level)"
        }
    }
    var costToNextLevel: Int {
        switch(level) {
            case 1: return 50
            case 2: return 100
            case 3: return 0
            default: return 0
        }
    }
    var position: (Int, Int)
    var img: String
    
    init(name: String, level: Int, position: (Int, Int)) {
        self.id = UUID()
        self.name = name
        self.level = level
        self.position = position
        self.img = "\(name).\(level)"
    }
    
    func createCopy(at position: (Int, Int)) -> Tower {
        return Tower(name: self.name, level: self.level, position: position)
    }
}
