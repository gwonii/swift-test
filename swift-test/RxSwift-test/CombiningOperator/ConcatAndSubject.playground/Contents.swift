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

concatCombination
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

subject.onNext("shoot")

sleep(1)
print("case1 end\n")

// MARK: - Case2 subject with take

let subject2 = PublishSubject<String>()

let concatCombination2 = Observable<String>.concat(
    just1,
    subject2
        .asObservable()
        .take(1),
    just2,
    just3
)

concatCombination2
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

subject2.onNext("shoot")

sleep(1)
print("case2 end\n")
