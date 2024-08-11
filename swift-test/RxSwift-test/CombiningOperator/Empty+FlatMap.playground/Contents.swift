import UIKit
import RxSwift

let disposeBag = DisposeBag()

let empty = Observable<Int>.empty()

empty
    .flatMap { int -> Observable<String> in
        return .just("\(int)")
    }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)


empty
    .flatMapLatest { int -> Observable<String> in
        return .just("\(int)")
    }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)

sleep(1)
print("---end---")
