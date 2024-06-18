import UIKit
import RxSwift

let completable1 = Completable.create { completable in
    print("Completable 1")
    completable(.completed)
    return Disposables.create()
}

let completable2 = Completable.create { completable in
    print("Completable 2")
    completable(.completed)
    return Disposables.create()
}

let completable3 = Completable.create { completable in
    print("Completable 3")
    completable(.completed)
    return Disposables.create()
}

let completableMerge = Observable<Never>.merge([
    completable1.asObservable(),
    completable2.asObservable(),
    completable3.asObservable()
])
.asCompletable()

_ = completableMerge
    .do(onCompleted: {
        print("all completed")
    })
    .subscribe()
