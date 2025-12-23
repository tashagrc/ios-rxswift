# Rx Swift

## Observable

### The basic

```swift
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
```

### Disposable
Ada 2 cara, dispose() dan disposed(by:)
- dispose() manual satu2
- disposed() pakai disposeBag
```swift
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
```

Nanti di main class, kalau pakai disposeBag, berhentiinnya kayak gini:
```swift
DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
    self?.disposableView = nil
}
```
