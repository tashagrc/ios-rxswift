//
//  FileReader.swift
//  ios-rxswift
//
//  Created by Natasha Radika on 23/12/25.
//

import RxSwift
import Foundation

class FileReader {
    
    let disposeBag = DisposeBag()
    
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    init() {
        loadText(from: "hello")
            .subscribe { value in
                switch value {
                case .success(let string):
                    print(string)
                case .failure(let error):
                    print(error)
                }
            }.disposed(by: disposeBag)
    }
    
    func loadText(from name: String) -> Single<String> {
        return Single.create { single in
            // bikin disposable dulu, karena subscribe closure buat create expect disposable sebagai return type
            let disposable = Disposables.create()
            
            // dapetin filepath name
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.failure(FileReadError.fileNotFound))
                return disposable
            }
            
            // dapetin data dari filepath itu
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.failure(FileReadError.unreadable))
                return disposable
            }
            
            // convert data ke string
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.failure(FileReadError.encodingFailed))
                return disposable
            }
            
            single(.success(contents))
            return disposable
        }
    }
}
