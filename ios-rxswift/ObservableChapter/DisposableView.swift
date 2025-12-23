//
//  DisposableView.swift
//  ios-rxswift
//
//  Created by Natasha Radika on 23/12/25.
//
import RxSwift
import Foundation

class DisposableView {
    
    let observable: Observable<Int>
    // dispose bag is for continuous events
    let disposeBag: DisposeBag
    init() {
        observable = Observable<Int>.interval(
            .seconds(1),
            scheduler: MainScheduler.instance
        )
        disposeBag = DisposeBag()
        disposeExample() // this will stop after 3 sec
        // dispose2() // this wont stop forever
    }
    
    private func disposeExample() {
        let subscription = observable.subscribe({ event in
            print("observable 1: \(event)")
            // cara 2 
        }).disposed(by: disposeBag) // akan didispose ketika object ini diinisialisasi
        
        // cara 1
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            subscription.dispose()
//        }
        
    }
    
    private func dispose2() {
        let subscription2 = observable.subscribe({ event in
            print("observable 2: \(event)")
        })
    }
}
