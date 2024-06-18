import UIKit
import RxSwift

let source = Observable.of(1, 3, 5, 7, 9)

let observable2 = source
    .reduce(0, accumulator: { summary, newValue in
        return summary + newValue
    })

observable2.subscribe(onNext: { print($0) })

// print
//    25
