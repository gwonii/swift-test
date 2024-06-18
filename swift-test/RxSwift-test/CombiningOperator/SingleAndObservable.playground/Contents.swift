import UIKit
import RxSwift

struct SingleError: LocalizedError {}

let disposeBag = DisposeBag()

let singleSuccess = Single<String>.create { single in
    single(.success("single1"))
    return Disposables.create()
}

let singleFailure = Single<String>.create { single in
    single(.failure(SingleError()))
    return Disposables.create()
}

let observable1 = Observable<String>.create { observer in
    observer.onNext("observable1")
    return Disposables.create()
}

let observable2 = Observable<String>.create { observer in
    observer.onNext("observable2")
    return Disposables.create()
}

let observable3 = Observable<String>.create { observer in
    observer.onNext("observable3-1")
    sleep(1)
    observer.onNext("observable3-2")
    return Disposables.create()
}

let observables = Observable<String>.combineLatest([
    observable1.asObservable(),
    singleSuccess.asObservable(),
    observable2.asObservable(),
    observable3.asObservable()
])

observables
    .debug("--> Observable combineLatest")
    .subscribe()
    .disposed(by: disposeBag)

sleep(2)
print("-------------------------")

let observables2 = Observable<String>.combineLatest([
    observable1.asObservable(),
    singleFailure.asObservable()
        .catch { error in return .just(error.localizedDescription) },
    observable2.asObservable(),
    observable3.asObservable()
])

observables2
    .debug("--> Observable combineLatest")
    .subscribe()
    .disposed(by: disposeBag)

sleep(2)
