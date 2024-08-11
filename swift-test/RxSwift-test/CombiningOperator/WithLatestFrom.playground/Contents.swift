import UIKit
import RxSwift

let button = BehaviorSubject<Void>(value: ())
let textField = PublishSubject<String>()

let observable = button.withLatestFrom(textField)
_ = observable
    .subscribe(onNext: { print($0) })

button.onNext(())
textField.onNext("gw")
textField.onNext("gwonii")
button.onNext(())
textField.onNext("gwonii2")
button.onNext(())
textField.onNext("gwonii3")

// print
//    gwonii
//    gwonii2
