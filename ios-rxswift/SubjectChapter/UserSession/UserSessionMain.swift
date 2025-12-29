//
//  UserSessionMain.swift
//  ios-rxswift
//
//  Created by Natasha Radika on 29/12/25.
//

import Foundation
import RxSwift
import RxRelay

class UserSessionMain {
    enum UserSession {
        case loggedIn, loggedOut
    }

    enum LoginError: Error {
        case invalidCredentials
    }

    let disposeBag = DisposeBag()

    // Create userSession BehaviorRelay of type UserSession with initial value of .loggedOut

    // Subscribe to receive next events from userSession
    
    init() {
        for i in 1...2 {
            let password = i % 2 == 0 ? "appleseed" : "password"
          
            logInWith(username: "johnny@appleseed.com", password: password) { error in
                guard error == nil else {
                    print(error!)
                    return
                }
            
                print("User logged in.")
            }
          
          performActionRequiringLoggedInUser {
              print("Successfully did something only a logged in user can do.")
          }
        }
    }
    
    func logInWith(username: String, password: String, completion: (Error?) -> Void) {
      guard username == "johnny@appleseed.com",
            password == "appleseed" else {
          completion(LoginError.invalidCredentials)
          return
      }
      
      // Update userSession
    }

    func logOut() {
        // Update userSession
    }

    func performActionRequiringLoggedInUser(_ action: () -> Void) {
        // Ensure that userSession is loggedIn and then execute action()
    }
}
