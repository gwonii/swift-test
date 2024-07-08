import UIKit
import RxSwift

let disposeBag = DisposeBag()

let subject = BehaviorSubject<String>(value: "")

subject
    .do(onNext: {
        print("\($0)")
    })
    .flatMapLatest { text -> Observable<Int> in
        if text == "hoho" {
            return Observable<Int>.timer(.seconds(2), scheduler: ConcurrentMainScheduler.instance)
        } else {
            return .empty()
        }
    }
    .subscribe(onNext: { count in
        print("The end")
    })
    .disposed(by: disposeBag)

subject.onNext("hi")
subject.onNext("hoho")
subject.onNext("hi2")
subject.onNext("hi3")
subject.onNext("hi4")
subject.onNext("hoho")

sleep(3)

