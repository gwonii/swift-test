import UIKit
import RxSwift
import RxRelay

let subject1 = PublishSubject<Int>()
let relay1 = BehaviorRelay<Int>(value: 0)

let disposeBag = DisposeBag()

subject1
    .filter { $0 > 10 }
    .do(onNext: {
        print("[subject1] first value is \($0)")
    })
    .timeout(.seconds(1), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .default))
    .catch { _ in return subject1.asObservable() }
    .do(onNext: {
        print("[subject1] second value is \($0)")
    })
    .subscribe()
    .disposed(by: disposeBag)

relay1
    .filter { $0 > 10 }
    .do(onNext: {
        print("[relay1] first value is \($0)")
    })
    .timeout(.seconds(1), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .default))
    .catch { _ in return relay1.asObservable() }
    .do(onNext: {
        print("[relay1] second value is \($0)")
    })
    .subscribe()
    .disposed(by: disposeBag)

relay1.accept(1)
relay1.accept(2)
relay1.accept(3)
subject1.onNext(1)
subject1.onNext(2)
subject1.onNext(3)

sleep(2)

relay1.accept(111)
subject1.onNext(111)

sleep(3)
print("excutor is end (1)")

// result
///    [relay1] second value is 3
///    [relay1] second value is 111
///    [subject1] second value is 111
///    excutor is end

print("\n------------------------\n")

// MARK: - catch 에 단일 방출 observable 을 사용하는 경우
/// - catchAndReturn 또는 catch { .just }  와 같이 사용한다면
/// timeout error 방출 후에 dispose 수행됨

let subject2 = PublishSubject<Int>()

subject2
    .filter { $0 > 10 }
    .do(onNext: {
        print("[subject2] first value is \($0)")
    })
    .timeout(.seconds(1), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .default))
    .catchAndReturn(-1)
    .do(onNext: {
        print("[subject2] second value is \($0)")
    })
    .subscribe()
    .disposed(by: disposeBag)

subject2.onNext(1)
subject2.onNext(2)
subject2.onNext(3)
sleep(2)
subject2.onNext(111)

sleep(3)
print("excutor is end (2)")

// result
/// [subject2] second value is -1
/// excutor is end (2)
