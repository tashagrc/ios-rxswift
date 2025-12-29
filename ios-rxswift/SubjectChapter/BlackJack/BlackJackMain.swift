//
//  BlackJackMain.swift
//  ios-rxswift
//
//  Created by Natasha Radika on 29/12/25.
//

import RxSwift
import Foundation

class BlackJackMain {
    let disposeBag = DisposeBag()
    let dealtHand = PublishSubject<[(String, Int)]>()
    
    init() {
        // Add subscription to dealtHand here
        // subscribe to dealtHand and handle next and error events. For next events, print a string containing the results returned from calling cardString(for:) and points(for:). For error events just print the error.
        deal(3)
    }
    
    func deal(_ cardCount: UInt) {
        var deck = cards
        var cardsRemaining: UInt32 = 52
        var hand = [(String, Int)]()
      
        for _ in 0..<cardCount {
            let randomIndex = Int(arc4random_uniform(cardsRemaining))
            hand.append(deck[randomIndex])
            deck.remove(at: randomIndex)
            cardsRemaining -= 1
        }
      
        // Add code to update dealtHand here
        // evaluate the result returned from calling points(for:), passing the hand array
        // if the result is greater than 21, add the error HandError.busted onto dealtHand with the points that caused the hand to bust. Otherwise, add hand into dealtHand as a next event
      
    }
}
