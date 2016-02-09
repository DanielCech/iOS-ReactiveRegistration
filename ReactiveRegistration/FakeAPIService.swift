//
//  RegistrationViewController.swift
//  ReactiveRegistration
//
//  Created by Dan on 09.02.16.
//  Copyright © 2016 Dan Cech. All rights reserved.
//

import ReactiveCocoa


public func delay(delay: Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


class FakeAPIService {

    static let sharedInstance = FakeAPIService()
    
    func validateCreditCardNumber(number: String) -> SignalProducer<Bool, NoError>
    {
        return SignalProducer { sink, disposable in
            
            delay(2) {
                sink.sendNext(number == "123456")
                sink.sendCompleted()
            }
            
        }
    }
    
    

}
