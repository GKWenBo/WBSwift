import UIKit

//ListIndex
public struct ListIndex<Element>: CustomStringConvertible {
    fileprivate let node: Node<Element>
    fileprivate let tag: Int
    
    public var description: String {
        return "IndexTag: \(tag)"
    }
}

//实现List
struct List<Element>: Collection {
    typealias Index = ListIndex<Element>
    
    var startIndex: Index
    let endIndex: Index
    
    subscript(position: Index) -> Element {
        switch position.node {
        case .end:
            fatalError("out of range")
        case let .node(value, next: _):
            return value
            
        }
    }
    
    func index(after i: Index) -> Index {
        switch i.node {
        case .end:
            fatalError("out of range")
        case let .node(_, next):
            return Index(node: next, tag: i.tag - 1)
        }
    }
    
}

enum Node<Element> {
    case end
    indirect case node(Element, next: Node<Element>)
}

extension Node {
    func insert(_ value: Element) -> Node {
        return .node(value, next: self)
    }
}

//
extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        startIndex = Index(node:
            elements.reversed().reduce(.end) {
                $0.insert($1)
        }, tag: elements.count)
        
        endIndex = Index(node: .end, tag: 0)
    }
}


//两个最基本的操作：push和pop
extension List {
    mutating func push(_ value: Element) {
        startIndex = Index(
            node: startIndex.node.insert(value),
            tag: startIndex.tag + 1)
    }
    
    mutating func pop() -> Index {
        let ret = startIndex
        startIndex = index(after: startIndex)
        return ret
    }
    
}

extension List: CustomStringConvertible {
    var description: String {
        let values = self.map {
            String(describing: $0)
            }.joined(separator: ", ")
        
        return "List: \(values)"
    }
}

extension ListIndex: Comparable {
    public static func ==<T> (lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
        return lhs.tag == rhs.tag
    }
    
    public static func < <T> (lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
        return lhs.tag > rhs.tag
    }
}

//让List是一个Sequence
extension List: IteratorProtocol, Sequence {
    mutating func next() -> Element? {
        switch pop().node {
        case .end:
            return nil
        case let .node(value, _):
            return value
        }
    }
}

extension List {
    var count: Int {
        return startIndex.tag - endIndex.tag
    }
}

func == <T: Equatable>(
    lhs: List<T>,
    rhs: List<T>) -> Bool {
    return lhs.elementsEqual(rhs)
}


//let list1: List = [1, 2, 3, 4, 5]
//for i in list1 {
//    print(i)
//}
//
//list1.forEach({
//    print($0)
//})
//
//list1.contains(1)

var list1: List = [1, 2, 3, 4, 5]
var list2: List = [1, 2, 3, 4, 5]


var begin = list1.makeIterator()
begin.next()
list1.count
list1.first
list1.firstIndex(of: 5)

list1.push(11)
list1.pop()

list1 == list2
