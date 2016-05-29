import Foundation

let ref = Firebase(url: "https://blurb.firebaseio.com")

// BlabTree structure with Blabs as vertices
class Blab {
    var profileName: String
    var blabString: String
    let parent: Blab?
    let timeInterval: Double
    
    var neighbors: [Edge]
    var visited: Bool
    
    init() {
        self.profileName = ""
        self.blabString = ""
        self.parent = nil
        self.timeInterval = 0.0
        self.neighbors = [Edge]()
        visited = false
    }
    
    init(profileName: String, blabString: String, parent: Blab?, timeInterval: Double) {
        self.profileName = profileName
        self.blabString = blabString
        self.parent = parent
        self.timeInterval = timeInterval
        self.neighbors = [Edge]()
        visited = false
    }
}

func == (a: Blab, b: Blab) -> Bool {
    return a.profileName == b.profileName && a.blabString == b.blabString && a.timeInterval == b.timeInterval
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
    
// Returns the sum of all the weights in the graph
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
    
// Graph traversal functions
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
let date1 = NSDate(timeIntervalSinceNow: -500.0)
let date2 = NSDate(timeIntervalSinceNow: -3800.0)
let date3 = NSDate(timeIntervalSinceNow: -467000.0)
let date4 = NSDate(timeIntervalSinceNow: -724120.0)

// Should be done in the home feed upon posting a blab, as well as in the reply mechanism
let testBlab1 = Blab(profileName: "Stine", blabString: "Can we go to Grizzly Peak?", parent: nil, timeInterval: date1.timeIntervalSince1970)

let testBlab2 = Blab(profileName: "Nagoogin", blabString: "It smells like asparagus piss", parent: nil, timeInterval: date2.timeIntervalSince1970)

let testBlab3 = Blab(profileName: "Posadinho", blabString: "I'm a light blue Bruin", parent: nil, timeInterval: date3.timeIntervalSince1970)

let testBlab4 = Blab(profileName: "Jungsoo", blabString: "I like Kim Chi Noodles", parent: nil, timeInterval: date4.timeIntervalSince1970)

// User Struct

struct User {
    let uid: String
    let email: String
    
    // Initialize a user from Firebase
    init(authData: FAuthData) {
        uid = authData.uid
        email = authData.providerData["email"] as! String
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}

func getDate(timeInterval: Double) -> NSDate {
     return NSDate(timeIntervalSince1970: timeInterval)
}

