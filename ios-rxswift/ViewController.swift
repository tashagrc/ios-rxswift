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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // publishSubjectExample()
        // behaviorSubjectExample()
        // replaySubjectExample()
        // behaviorSubjectExample2()
        // publishRelaySubjectExample()
        behaviorRelaySubjectExample()
    }
    
    private func publishSubjectExample() {
        let subject = PublishSubject<String>()
        // put something to the subject
        subject.on(.next("is anyone listening?"))
        // publish subject cuma emit ke current subcriber, jadi ketika belum subscribe ketika event ditambahin, maka kita ga akan print apa2 ketika itu subscribe
        let subscriptionOne = subject.subscribe(onNext: { string in
            print(string)
        })
        // setelah tambahin ini baru yg atas akan keprint
        subject.on(.next("hello from the other side"))
        // syntax lain dari on(.next())
        subject.onNext("another lemon tea pls!")
        
        let subscriptionTwo = subject.subscribe { event in
            print("subs2: ", event.element ?? event)
        }
        
        subject.onNext("hiyaa lets gooo")
        
        subscriptionOne.dispose()
        subject.onNext("cheers to the one that we got")
        
        /**
         
         hello from the other side
         another lemon tea pls!
         hiyaa lets gooo
         subs2:  hiyaa lets gooo
         subs2:  cheers to the one that we got // notice that subs 1 does not get this
         
         */
        
        subject.onCompleted() // subjectnya diterminate // it will print subs2: completed
        subject.onNext("this wont print: im hungry i wanna eat a fish")
        
        subscriptionTwo.dispose()
        
        subject.subscribe {
            print("subs 3: ", $0.element ?? $0)
        }.disposed(by: disposeBag)
        // ga akan keprint sama subs 3 karena subjectnya udah diterminate
        // tapi tetap akan print subs3: completed
        subject.onNext("this wont print: there's a bowl of honey over there")
    }
    
    private func behaviorSubjectExample() {
        let subject = BehaviorSubject(value: "Initial value")
        
        subject.onNext("first value")
        // walau baru subscribe setelah valuenya di-init, tetap bakal terima latest valuenya
        subject.subscribe { event in
            print("subs 1: ", (event.element ?? event.error) ?? event)
        }.disposed(by: disposeBag)
        
        // walau setelah subscribe, akan ada event error, latest event saat subscribe juga akan diprint yang "first value", karena immediatelly after subscribe, dia akan print latest event
        subject.onError(MyError.anError)
        
        subject.subscribe { event in
            print("subs 2: ", (event.element ?? event.error) ?? event)
        }
        .disposed(by: disposeBag)
    }
    
    private func behaviorSubjectExample2() {
        let subject = BehaviorSubject(value: "Initial value")
        subject.onNext("blue straw red straw")
        
        subject.subscribe { event in
            print("subs 1 simple: ", (event.element ?? event.error) ?? event)
        }.disposed(by: disposeBag)
        
        subject.onNext("it's not a joke")
    }
    
    private func replaySubjectExample() {
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        subject.onNext("do you even care?")
        subject.onNext("please come back")
        subject.onNext("i miss you")
        
        // both of these 2 subs only print the latest 2 events
        /**
         
         subs 1:  please come back
         subs 1:  i miss you
         subs 2:  please come back
         subs 2:  i miss you
         
         */
        subject.subscribe { event in
            print("subs 1: ", (event.element ?? event.error) ?? event)
        }.disposed(by: disposeBag)
        
        subject.subscribe { event in
            print("subs 2: ", (event.element ?? event.error) ?? event)
        }.disposed(by: disposeBag)
        
        // end
        
        // after adding this
        /**
         subs 1:  hey, i didn't mean it
         subs 2:  hey, i didn't mean it // both subscriber will print the latest element
         subs 3:  i miss you
         subs 3:  hey, i didn't mean it // 3rd subject will replay the last 2 events
         */
        subject.onNext("hey, i didn't mean it")
        
        // added later, after adding the error
        /**
         subs 1:  anError
         subs 2:  anError
         subs 3:  i miss you
         subs 3:  hey, i didn't mean it
         subs 3:  anError
         */
        subject.onError(MyError.anError) // even though we add error before subs 3 subscribe, we still get the prev 2 events
        
        // added later
        subject.dispose() // after adding this, we cannot subscribe again
        
        subject.subscribe { event in
            print("subs 3: ", (event.element ?? event.error) ?? event)
        }.disposed(by: disposeBag)
    }
    
    private func publishRelaySubjectExample() {
        // this is exacly like Publish Subject
        let relay = PublishRelay<String>()
        
        relay.accept("knock knock")
        
        relay.subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
        
        relay.accept("i put my jacket on") // only print latest element
    }
    
    private func behaviorRelaySubjectExample() {
        // will receive the latest element before subscribing + the elements after that
        let relay = BehaviorRelay(value: "the world begin with a bowl of meat soup")
        relay.accept("then a cute rabbit appears from thin air")
        
        relay.subscribe { event in
            print("subs 1: ", (event.element ?? event.error) ?? event)
        }.disposed(by: disposeBag)
        
        relay.accept("the rabbit started to eat a lot of meat soup")
        relay.subscribe { event in
            print("subs 2: ", (event.element ?? event.error) ?? event)
        }.disposed(by: disposeBag)
        
        relay.accept("then a wild boar appears from the meat soup")
    }
}
