import UIKit

/*
 封装某些作用于某种数据结构中各元素的操作，它可以在不改变数据结构的前提下定义作用于这些元素的新的操作。
 */

protocol PlanetVisitor {
    func visit(planet: MoonJedha)
    func visit(planet: PlanetAlderaan)
    func visit(planet: PlanetCoruscant)
    func visit(planet: PlanetTatooine)
}

protocol Planet {
    func accept(visitor: PlanetVisitor)
}

final class MoonJedha: Planet {
    func accept(visitor: PlanetVisitor) {
        visitor.visit(planet: self)
    }
}

final class PlanetAlderaan: Planet {
    func accept(visitor: PlanetVisitor) {
        visitor.visit(planet: self)
    }
}

final class PlanetCoruscant: Planet {
    func accept(visitor: PlanetVisitor) {
        visitor.visit(planet: self)
    }
}

final class PlanetTatooine: Planet {
    func accept(visitor: PlanetVisitor) {
        visitor.visit(planet: self)
    }
}

final class NameVisitor: PlanetVisitor {
    var name = ""
    func visit(planet: MoonJedha) {
        name = "MoonJedha"
    }
    
    func visit(planet: PlanetAlderaan) {
        name = "PlanetAlderaan"
    }
    
    func visit(planet: PlanetCoruscant) {
        name = "PlanetCoruscant"
    }
    
    func visit(planet: PlanetTatooine) {
        name = "PlanetTatooine"
    }
}

/// usage
let planets: [Planet] = [PlanetAlderaan(), PlanetCoruscant(), PlanetTatooine(), MoonJedha()]

let names = planets.map { (planet: Planet) -> String in
    let visitor = NameVisitor()
    planet.accept(visitor: visitor)

    return visitor.name
}
print(names)
