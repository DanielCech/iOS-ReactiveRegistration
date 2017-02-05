//
//  RegistrationViewModel.swift
//  ReactiveRegistration
//
//  Created by Dan on 09.02.16.
//  Copyright © 2016 Dan Cech. All rights reserved.
//


//import UIKit
import ReactiveSwift


class RegistrationViewModel: NSObject {

    enum CardStatus {
        case notVerified
        case verifying
        case verified
        case denied
    }
    
    
    var email = MutableProperty<String>("")
    var password = MutableProperty<String>("")
    var passwordAgain = MutableProperty<String>("")
    var useCreditCard = MutableProperty<Bool>(false)
    var creditCardNumber = MutableProperty<String>("")
    var cardStatus = MutableProperty<CardStatus>(.notVerified)
 
    var correctEmailProducer: SignalProducer<Bool, NoError>!
    var correctPasswordProducer: SignalProducer<Bool, NoError>!
    var correctCreditCardProducer: SignalProducer<Bool, NoError>!
    var correctInputProducer: SignalProducer<Bool, NoError>!
    
    
    func initBindings()
    {
        creditCardNumber.producer.startWithValues { _ in
            self.cardStatus.value = .notVerified
        }
        
        correctEmailProducer =
            email.producer
                .map({ (emailText) -> Bool in
                    emailText.isValidEmail()
                })
        
        
        correctPasswordProducer =
            SignalProducer.combineLatest(password.producer, passwordAgain.producer)
                .map { (passwordText, passwordAgainText) -> Bool in
                    return (passwordText.characters.count > 5) && (passwordText == passwordAgainText)
                }
        
        
        correctCreditCardProducer =
            SignalProducer.combineLatest(useCreditCard.producer, cardStatus.producer)
                .map({ (useCard, cardStatus) -> Bool in
                    if !useCard {
                        return true
                    }
                    else if cardStatus == .verified {
                        return true
                    }
                    
                    return false
                })
        
        correctInputProducer =
            SignalProducer.combineLatest(correctEmailProducer, correctPasswordProducer, correctCreditCardProducer)
            .map({ (email, password, card) -> Bool in
                return email && password && card
            })

    }
    
    
    func verifyCardNumber()
    {
        cardStatus.value = .verifying
        
        FakeAPIService.sharedInstance.validateCreditCardNumber(creditCardNumber.value)
        .startWithValues { valid in
            
            self.cardStatus.value = valid ? .verified : .denied
        }
    }
    
    
    func createSummaryViewModel() -> SummaryViewModel
    {
        let summaryViewModel = SummaryViewModel()
        summaryViewModel.email = email.value
        summaryViewModel.creditCardNumber = useCreditCard.value ? creditCardNumber.value : nil
        
        return summaryViewModel
    }
    
}
