import UIKit
import RxSwift

let disposeBag = DisposeBag()

let subject = PublishSubject<String>()

let observable = Observable<String>.create { observer in

    observer.onNext("observable(abc)")
    observer.onNext("observable(abcd)")
    observer.onNext("observable(abc)")
    observer.onNext("observable(abc)")

    return Disposables.create()
}

subject
    .distinctUntilChanged()
    .subscribe(onNext: {
        print("emit element: \($0)")
    })
    .disposed(by: disposeBag)


subject.onNext("subject(abc)")
subject.onNext("subject(abcd)")
subject.onNext("subject(abc)")
subject.onNext("subject(abc)")


observable
    .distinctUntilChanged()
    .subscribe(onNext: {
        print("emit element: \($0)")
    })
    .disposed(by: disposeBag)
