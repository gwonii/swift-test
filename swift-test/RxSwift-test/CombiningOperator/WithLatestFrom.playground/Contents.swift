import UIKit
import RxSwift

let button = PublishSubject<Void>()
let textField = PublishSubject<String>()

let observable = button.withLatestFrom(textField)
_ = observable
    .subscribe(onNext: { print($0) })

textField.onNext("gw")
textField.onNext("gwonii")
button.onNext(())
textField.onNext("gwonii2")
button.onNext(())

// print
//    gwonii
//    gwonii2
