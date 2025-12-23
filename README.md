# Rx Swift

## Introduction
**Observable**: ini bikin consumer bisa subscribe ke events, value etc dari objek lain

Observable bisa ngeluarin 3 events ini, observers bisa terima 3 events ini

- next: latest data value
- completed: terminate event sequence, wont emit additional events
- error: terminate with error and wont emit additional events

ada 2 jenis observable sequences:

- finite: suatu saat eventsnya akan terminate, misal download file
- infinite: ga akan pernah selesai, cth device orientation change. jadi skip onError dan onCompleted

**Operators**

ini kayak bisa ngefilter data, etc

**Schedulers**

ini buat process jadi bisa run di main vs background etc, tanpa scheduler kita run in main semua

regular scheduler (dispatch queue): jalanin code ini di thread ini

rxswift: dari point ini, value dideliver di sheduler yang itu

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

### Create, primitive control of observable

```swift
let observable = Observable<String>.create { observer in
    observer.onNext("heloowwww")
    observer.onCompleted()
    // ini ga akan kepanggil setelah completed
    observer.onNext("miawww")
    return Disposables.create() // return disposable
}
observable.subscribe({ events in
    print("create: \(events)")
}).disposed(by: disposeBag)
```

outputnya ini:
```swift
create: next(heloowwww)
create: completed
```

kalau ga dicomplete atau error atau dispose, maka akan leak memory
```swift
let observable = Observable<String>.create { observer in
    observer.onNext("heloowwww")
    // observer.onError(MyError.anError)
   //  observer.onCompleted()
    // ini ga akan kepanggil setelah completed
    observer.onNext("miawww")
    return Disposables.create() // return disposable
}
observable.subscribe({ events in
    print("create: \(events)")
})
// .disposed(by: disposeBag)
```

### Observable factory
Function yang memproduksi fresh observable instance on demand
Calling the factory itu bukan subscribing, setiap call create new observable

deferred -> code di dalam deferred ini run saat subscription time, bukan saat creation time, sehingga per subscriber dapat fresh state
```swift
Observable.deferred {
    return Observable.just(Date())
}
```

## Traits
traits itu kayak observable tapi lebih spesifik aja
traits lebih readable dan susah misuse dibanding observable karena lebih spesifik
traits cuma terima value sekali trs udah done.
- Single -> akan mengeluarkan success(value) atau error(error) event. success(value) isinya kombinasi next dan completed (sekali aja barengan dikeluarinnya).
- Completable -> cuma akan ngeluarin completed atau error(error) event, ga akan keluarin value apapun. Bisa dipakai kalo kita ga peduli dia keluarin value apa.
- Maybe -> campuran antara Single dan Completable, bisa keluarin success(value), completable, atau error(error). Tapi bedanya sama Observable, maybe cuma bisa keluarin 1 value lalu selesai, ga repeated.

## Rule of thumb: Observable and Traits

- Repeated events (kayak button taps, text field changes, web socket, notif, location update) -> Observable
- API call (cuma 1 response dan request, trs selesai)-> Single
- Save/ delete, logout, clear cache (ga peduli dengan datanya, cuma peduli itu sukses atau fail) -> Completable
- Optional fetch (bisa jadi ada value atau nothing, atau error misal cache lookup atau database query) -> Maybe


