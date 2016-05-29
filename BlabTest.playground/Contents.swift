
import Foundation

// BlabTree structure with Blab as a vertex
class Blab {
    var blabString: String
    var parent: Blab?
    var neighbors: [Edge]
    var visited: Bool
    
    init() {
        self.blabString = ""
        self.neighbors = [Edge]()
        visited = false
    }
    
    init(blabString: String, parent: Blab?) {
        self.blabString = blabString
        self.parent = parent
        self.neighbors = [Edge]()
        visited = false
    }
}

func == (a: Blab, b: Blab) -> Bool {
    return a.blabString == b.blabString
}

class Edge {
    var neighbor: Blab
    var weight: Int
    
    init() {
        self.neighbor = Blab()
        weight = 0
    }
}

class BlabTree {
    var map: [Blab]
    var influence: Int
    
    init() {
        map = [Blab]()
        self.influence = 0
    }
    
    func addBlab(blab: Blab) {
        map.append(blab)
    }
    
    func addBlab(blabString: String) -> Blab {
        let newBlab: Blab = Blab()
        newBlab.blabString = blabString
        map.append(newBlab)
        
        return newBlab
    }
    
    func getWeight(blab: Blab) -> Int {
        var focusBlab: Blab = blab
        var length: Int = 0
        while focusBlab.parent != nil {
            focusBlab = focusBlab.parent!
            length += 1
        }
        switch length {
        case 1:
            return 10
        case 2:
            return 8
        case 3:
            return 6
        case 4:
            return 4
        case 5:
            return 5
        default:
            return 1
        }
    }
    
    func addEdge(neighbor: Blab) {
        // Check for the parent of the blab being connected in the map.
        // Check how many connections from the root for the weight
        // Weights should go 10, 8, 6, 4, 2, 1...
        if let parent = neighbor.parent {
            for blab in map {
                if blab == parent {
                    let newEdge = Edge()
                    newEdge.neighbor = neighbor
                    newEdge.weight = self.getWeight(neighbor) // Need to implement a path algorithm
                    influence += newEdge.weight
                    blab.neighbors.append(newEdge)
                    
                }
            }
        }
    }
    
    func traverseBFS(source: Blab) {
        var blabQueue : [Blab] = [Blab]()
        blabQueue.append(source)
        while !blabQueue.isEmpty {
            let focusBlab = blabQueue.popLast() as Blab!
            for edge in focusBlab.neighbors {
                if !edge.neighbor.visited {
                    blabQueue.append(edge.neighbor)
                }
            }
            focusBlab.visited = true
            print(focusBlab.blabString)
        }
        print("BFS graph traversal complete")
    }
    
    func traverseDFS(source: Blab) {
        source.visited = true
        print(source.blabString)
        for edge in source.neighbors {
            if !edge.neighbor.visited {
                traverseDFS(edge.neighbor)
            }
        }
    }
    
}
// End of BlabTree class

var myGraph = BlabTree()

let blab1 = Blab(blabString: "A", parent: nil)
let blab2 = Blab(blabString: "B", parent: blab1)
let blab3 = Blab(blabString: "C", parent: blab1)
let blab4 = Blab(blabString: "D", parent: blab3)
let blab5 = Blab(blabString: "E", parent: blab4)
let blab6 = Blab(blabString: "F", parent: blab3)
let blab7 = Blab(blabString: "G", parent: blab4)

let blabs = [blab1, blab2, blab3, blab4, blab5, blab6, blab7]
for blab in blabs {
    myGraph.addBlab(blab)
}

for blab in myGraph.map {
    myGraph.addEdge(blab)
}

myGraph.traverseDFS(myGraph.map[0])
print(myGraph.influence)

let date1 = NSDate(timeIntervalSinceNow: -500.0)
print(date1))

