import UIKit
import RxSwift

let subject: PublishSubject<String> = .init()
let subject2: PublishSubject<String> = .init()
let disposeBag: DisposeBag = .init()

_ = subject
    .asObservable()
    .take(1)
    .asSingle()
    .subscribe(onSuccess: { (item) in
        print("subject: \(item)")
    })

subject2
    .asObservable()
    .take(1)
    .asSingle()
    .subscribe(onSuccess: { (item) in
        print("subject2: \(item)")
    })
    .disposed(by: disposeBag)


subject.onNext("shoot~")
subject2.onNext("shoot~")



