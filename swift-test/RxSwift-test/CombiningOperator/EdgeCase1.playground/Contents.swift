import UIKit
import RxSwift

var subjectA = BehaviorSubject<String>(value: "")
var subjectB = BehaviorSubject<String>(value: "")

//let disposeBag = DisposeBag()

// MARK: - Case1
print("Case1")

var disposable: Disposable!

let combinedAB = Observable.zip(subjectA, subjectB) { a, b in
    return "A: \(a), B: \(b)"
}

let onlyB = subjectB.map { b in
    return "Only B: \(b)"
}

let mergedObservable = Observable.merge(combinedAB, onlyB)

// 결과를 구독
disposable = mergedObservable
    .subscribe(onNext: { result in
    print("case1: \(result)")
})


subjectA.onNext("AAA")
subjectB.onNext("BBB")

subjectB.onNext("BBBB")

sleep(1)
disposable.dispose()
print("------------------\n")

// Case1
// let mergedObservable = Observable.merge(combinedAB, onlyB)
//    A: , B:
//    Only B:
//    A: AAA, B: BBB
//    Only B: BBB
//    Only B: BBBB

// MARK: - Case2
print("Case2")

var disposable2: Disposable!
subjectA = BehaviorSubject<String>(value: "")
subjectB = BehaviorSubject<String>(value: "")

let combinedAB2 = Observable.zip(subjectA, subjectB) { a, b in
    return "A: \(a), B: \(b)"
}

let onlyB2 = subjectB.distinctUntilChanged().map { b in
    return "Only B: \(b)"
}

let mergedObservable2 = Observable.merge(combinedAB2, onlyB2)

// 결과를 구독
disposable2 = mergedObservable2.subscribe(onNext: { result in
    print("case2: \(result)")
})


subjectA.onNext("AAA")
subjectB.onNext("BBB")

subjectB.onNext("BBBB")

sleep(1)
disposable2.dispose()
print("--------------------\n")


// MARK: - Case3
print("Case3")

subjectA = BehaviorSubject<String>(value: "")
subjectB = BehaviorSubject<String>(value: "")
let disposable3: Disposable!

let aTracker = BehaviorSubject<String>(value: "")
let bTracker = BehaviorSubject<String>(value: "")

// Combined observableA and observableB using zip
let combinedAB3 = Observable
    .zip(subjectA, subjectB) { a, b in
        aTracker.onNext(a)
        bTracker.onNext(b)
        return "A: \(a), B: \(b)"
    }

let onlyA3 = subjectA
    .distinctUntilChanged()
    .withLatestFrom(aTracker) { ($0, $1) }
    .filter { $0 != $1 }
    .map { $0.0 }
    .do(onNext: { aTracker.onNext($0) })
    .map { b in
        return "Only A: \(b)"
    }

let onlyB3 = subjectB
    .distinctUntilChanged()
    .withLatestFrom(bTracker) { ($0, $1) }
    .filter { $0 != $1 }
    .map { $0.0 }
    .do(onNext: { bTracker.onNext($0) })
    .map { b in
        return "Only B: \(b)"
    }

let mergedObservable3 = Observable.merge(combinedAB3, onlyA3 ,onlyB3)

// Subscribe to merged observable
disposable3 = mergedObservable3.subscribe(onNext: { result in
    print(result)
})

subjectA.onNext("AAA")
subjectB.onNext("BBB")

subjectB.onNext("BBBB")

sleep(1)
disposable3.dispose()
