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
        behaviorSubjectExample()
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
}
