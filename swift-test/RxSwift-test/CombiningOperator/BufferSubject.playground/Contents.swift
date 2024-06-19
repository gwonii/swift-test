import UIKit
import RxSwift
import RxRelay

let disposeBag = DisposeBag()

let subject1 = PublishSubject<String>()
let subject2 = PublishSubject<Void>()


let bufferedRelay = ReplayRelay<String>.createUnbound()

subject1
    .bind(to: bufferedRelay)
    .disposed(by: disposeBag)

subject2
    .asObservable()
    .flatMapLatest { a -> Observable<String> in
        return bufferedRelay.asObservable()
    }
    .subscribe(onNext: { value in
        print(value)
    })
    .disposed(by: disposeBag)

subject1.onNext("A")
subject1.onNext("B")

subject2.onNext(())

subject1.onNext("A")
subject1.onNext("B")
subject1.onNext("C")
subject1.onNext("D")
