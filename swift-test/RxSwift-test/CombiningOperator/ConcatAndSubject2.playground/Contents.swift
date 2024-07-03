import UIKit
import RxSwift

let disposeBag = DisposeBag()

// MARK: - Case1 normal subject

let subject = PublishSubject<String>()

let just1 = Observable<String>.just("1")
let just2 = Observable<String>.just("2")
let just3 = Observable<String>.just("3")

let concatCombination = Observable<String>.concat(
    just1,
    subject.asObservable(),
    just2,
    just3
)

subject.onNext("shoot0")
subject.onNext("shoot0")
subject.onNext("shoot0")

// subscribe 1
concatCombination
    .subscribe(onNext: {
        print("subscribe1: \($0)")
    })
    .disposed(by: disposeBag)

subject.onNext("shoot1")

// subscrbie 2
concatCombination
    .subscribe(onNext: {
        print("subscribe2: \($0)")
    })
    .disposed(by: disposeBag)

subject.onNext("shoot2")

// subscribe 3
concatCombination
    .subscribe(onNext: {
        print("subscribe3: \($0)")
    })
    .disposed(by: disposeBag)

subject.onNext("shoot3")

sleep(1)

// result
/// subscribe1: 1
/// subscribe1: shoot1
/// subscribe2: 1
/// subscribe1: shoot2
/// subscribe2: shoot2
/// subscribe3: 1
/// subscribe1: shoot3
/// subscribe2: shoot3
/// subscribe3: shoot3
