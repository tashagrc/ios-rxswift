//
//  ViewController.swift
//  ios-rxswift
//
//  Created by Natasha Radika on 22/12/25.
//

import UIKit
import RxSwift
import RxCocoa

enum MyError: Error {
    case anError
}

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    // var disposableView: DisposableView? = DisposableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // observableExample()
        // disposeExample()
        
        // kalo ga pake ini, disposable view akan run forever
        // cara 2 utk dispose, cek disposableView buat cara 1 dan 2
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
//            self?.disposableView = nil
//        }
        
        // createExample()
        
        observableFactoryExample()
    }
    
    private func observableExample() {
        let one = 1
        let two = 2
        let three = 3
        
        // just -> emits 1 value then completed
        let observable = Observable<Int>.just(one)
        // ctrl click -> liat dalemannya
        // opt click -> liat short docs
        observable.subscribe(onNext: { value in
            print("obv1: \(value)")
        }).disposed(by: disposeBag)
        
        // of -> emits multiple element passed as separate params
        let observable2 = Observable.of(one, two, three)
        observable2.subscribe(onNext: { value in
            print("obv2: \(value)")
        }).disposed(by: disposeBag)
        
        // from -> emits multiple element passed from array
        let observable3 = Observable.from([one, two, three])
        observable3.subscribe(onNext: { value in
            print("obv3: \(value)")
        }).disposed(by: disposeBag)
        
        // ini print eventnya bukan valuenya
        // subscribe to all events, not just value
        observable3.subscribe { event in
            print("hehehoho: \(event)")
        }
        
        // empty ga akan emit value, lalu langsung terminate
        let observable4 = Observable<Void>.empty()
        observable4.subscribe(onNext: { element in
            print(element)
        }, onCompleted: {
            print("empty completed")
        })
        
        // never ga akan emit value tapi ga akan terminate
        let observable5 = Observable<Void>.never()
        observable5.subscribe(
            onNext: { element in
                print(element)
            },
            onCompleted: {
                print("never completed")
            }
        )
        
        // range value
        let observable6 = Observable.range(start: 1, count: 5)
        observable6.subscribe(onNext: { value in
            print("obv6: \(value)")
        }).disposed(by: disposeBag)
    }

    private func disposeExample() {
        let observable = Observable.of("a", "b", "c")
        let subscription = observable.subscribe({ event in
            print("observable 1: \(event)")
        })
        
        subscription.dispose()
    }
    
    private func createExample() {
        // create -> build custom observable from scratch
        // kita bisa decide kapan value dikeluarkan, apa yg diemit, kapan stream completed/error
        
        let observable = Observable<String>.create { observer in
            observer.onNext("heloowwww")
             observer.onError(MyError.anError)
             observer.onCompleted()
            // ini ga akan kepanggil setelah completed
            observer.onNext("miawww")
            return Disposables.create() // return disposable
        }
        observable.subscribe({ events in
            print("create: \(events)")
        })
         .disposed(by: disposeBag)
    }
    
    private func observableFactoryExample() {
        // ini bakal kasih observable ke setiap subscriber
        // observable makers, not observable
        
        // kalo kita pake observable instance yang sama
        // bisa2 shared state, side effect cuma ketrigger sekali, ada bug etc
        
        var flip = false
        let factory: Observable<Int> = Observable.deferred {
            // ini buat nunjukin kalo observablenya created everytime
            flip.toggle()
            
            if flip {
                return Observable.of(1, 2, 3)
            } else {
                return Observable.of(4, 5, 6)
            }
        }
        
        for _ in 0...3 {
            factory.subscribe(onNext: {
                print($0, terminator: "")
            }).disposed(by: disposeBag)
            print()
        }
    }
}
