//
//  RegistrationViewController.swift
//  ReactiveRegistration
//
//  Created by Dan on 09.02.16.
//  Copyright © 2016 Dan Cech. All rights reserved.
//

import ReactiveSwift


public func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}


class FakeAPIService {

    static let sharedInstance = FakeAPIService()
    
    func validateCreditCardNumber(_ number: String) -> SignalProducer<Bool, NoError>
    {
        return SignalProducer { sink, disposable in
            
            delay(2) {
                sink.send(value: number == "123456")
                sink.sendCompleted()
            }
            
        }
    }
    
    

}
