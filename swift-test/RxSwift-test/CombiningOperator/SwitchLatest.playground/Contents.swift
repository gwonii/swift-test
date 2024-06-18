import UIKit
import RxSwift

let one = PublishSubject<String>()
let two = PublishSubject<String>()
let three = PublishSubject<String>()

let source = PublishSubject<Observable<String>>()

let observable = source.switchLatest()
let disposable = observable.subscribe(onNext: { print($0) })

// 3
source.onNext(one)
one.onNext("Some text from sequence one")
two.onNext("Some text from sequence two")

source.onNext(two)
two.onNext("More text from sequence two")
one.onNext("and also from sequence one")

source.onNext(three)
two.onNext("Why don't you see me?")
one.onNext("I'm alone, help me")
three.onNext("Hey it's three. I win")

source.onNext(one)
one.onNext("Nope. It's me, one!")

disposable.dispose()

/* Prints:
 Some text from sequence one
 More text from sequence two
 Hey it's three. I win
 Nope. It's me, one!
 */
