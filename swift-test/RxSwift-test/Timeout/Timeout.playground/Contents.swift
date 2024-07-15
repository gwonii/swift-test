import UIKit
import RxSwift


let disposeBag = DisposeBag()
let empty = Observable<String>.empty()
let never = Observable<String>.never()
let filteredSubject = PublishSubject<Int>()

// empty 는 바로 방출을 하는 것이기 때문에, timeout 되지 않는다...
empty
    .timeout(.seconds(1), scheduler: ConcurrentMainScheduler.instance)
    .catchAndReturn("empty - timeout")
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)


never
    .timeout(.seconds(1), scheduler: ConcurrentMainScheduler.instance)
    .catchAndReturn("never - timeout")
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)

filteredSubject
    .filter { $0 > 5 }
    .asObservable()
    .timeout(.seconds(1), scheduler: ConcurrentMainScheduler.instance)
    .catchAndReturn(-1)
    .subscribe(onNext: { print($0) })

filteredSubject.onNext(1)
filteredSubject.onNext(2)
filteredSubject.onNext(3)

sleep(2)

print("The end")
