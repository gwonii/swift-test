import UIKit

@propertyWrapper
public class Atomic<T> {
    public init(_ wrappedValue: T) {
        _wrappedValue = wrappedValue
    }

    public var wrappedValue: T {
        get {
            var currentValue: T!
            mutate { currentValue = $0 }
            return currentValue
        }

        set {
            mutate { $0 = newValue }
        }
    }

    private let lock = NSRecursiveLock()
    private var _wrappedValue: T

    public func mutate(_ changes: (_ value: inout T) -> Void) {
        lock.lock()
        changes(&_wrappedValue)
        lock.unlock()
    }
}

public extension Array where Element: Equatable {
    @discardableResult
    mutating func removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll(where: { items.contains($0) })
        return self
    }
}

var array = Atomic<[String]>([
    "aaa", "aab", "aac", "aba", "abb", "abc", "aca"
])

//var array = [
//    "aaa", "aab", "aac", "aba", "abb", "abc", "aca"
//]

let dispatchQueue = DispatchQueue(label: "1234", attributes: .concurrent)
let dispatchQueue2 = DispatchQueue(label: "12345")
let dispatchQueue3 = DispatchQueue(label: "123456")

dispatchQueue.async {
    for i in 1...100 {
                array.mutate {
                    $0.append("aaa\(i)")
                    print("[1-\(i)] appended array: \($0)")
                }
//         --
//        array.append("aaa\(i)")
//        print("[1-\(i)] appended array: \(array)")
    }
}

dispatchQueue.async {
    for i in 1...100 {
        array.mutate {
            $0.append("aaa\(i)")
            print("[2-\(i)] appended array: \($0)")
        }
        // --
//        array.append("aaa\(i)")
//        print("[2-\(i)] appended array: \(array)")
    }
}

//dispatchQueue.async {
//    for i in 1...100 {
//        array.mutate {
//            $0.append("aaa\(i)")
//            print("[3-\(i)] appended array: \($0)")
//        }
//        array.append("aaa\(i * 100)")
//        print("[3-\(i)] appended array: \(array)")
//    }
//}

dispatchQueue.async {
    for i in 1...100 {
        array.mutate {
            $0.removeAll(["aaa\(i)"])
            print("[X-\(i)] appended array: \($0)")
        }
        // --
//        array.removeAll(["aaa\(i)"])
//        print("[X-\(i)] removed array: \(array)")
    }
}
