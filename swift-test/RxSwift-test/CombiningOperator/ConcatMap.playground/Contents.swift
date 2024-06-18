import UIKit
import RxSwift

let sequences = ["Germany": Observable.of("Berlin", "Münich", "Frankfurt"),
                 "Spain": Observable.of("Madrid", "Barcelona", "Valencia")]

let observable = Observable.of("Germany", "Spain", "Korea")
    .concatMap({ country in
        sequences[country] ?? .just("empty")
    })

_ = observable
    .subscribe(onNext: { print($0) })

// print
//    Berlin
//    Münich
//    Frankfurt
//    Madrid
//    Barcelona
//    Valencia
//    empty
