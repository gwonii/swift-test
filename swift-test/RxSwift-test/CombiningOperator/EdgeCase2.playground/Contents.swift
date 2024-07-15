//
//  EdgeCase2.swift
//  RxSwift-test
//
//  Created by nhn on 7/15/24.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - 두 개의 trigger 를 사용하여 Observable 방출하기
/// condition1: mainSubject가 nil 인 경우 아무 로직이 수행되지 않도록 한다.
/// condition2: merge 에서 새로운 값이 방출되면, 로직이 수행된다.
/// condition3: mainSubject의 값이 변경되면, merge 는 "nil" 을 방출한다. ( 기존 subject1, subject2 의 값과 관계가 없어짐 )

let disposeBag = DisposeBag()

let mainSubject = BehaviorSubject<String?>(value: nil)

let subject1 = PublishSubject<String>()
let subject2 = PublishSubject<String>()
let merge = Observable<String>.merge(
    .just("nil"),
    subject1.asObservable(),
    subject2.asObservable()
)

mainSubject
    .compactMap { $0 }
    .flatMap { mainString -> Observable<(String, String)> in
        return merge
            .map { (mainString, $0) }
    }
    .subscribe { mainString, subString in
        print("result: \(mainString) \(subString)")
    }
    .disposed(by: disposeBag)


mainSubject.onNext("Hello")
// result: "Hello nil"

subject1.onNext(", world!")
// result: "Hello, world!"

mainSubject.onNext("My name is")
// result: "My name is nil"

