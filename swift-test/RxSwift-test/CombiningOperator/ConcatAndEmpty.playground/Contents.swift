import UIKit
import RxSwift

let disposeBag = DisposeBag()

let just1 = Observable<Int>.just(1)
let just2 = Observable<Int>.just(2)
let just3 = Observable<Int>.just(3)

let empty = Observable<Int>.empty()

let combination: Observable<Int> = .concat(just1, empty, just2, just3)

combination
    .do(onNext: {
        print("\($0)")
    })
    .subscribe()
    .disposed(by: disposeBag)

sleep(1)

// result
/// 1
/// 2
/// 3
