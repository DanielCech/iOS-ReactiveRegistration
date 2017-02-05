//
//  RegistrationViewController.swift
//  ReactiveRegistration
//
//  Created by Dan on 09.02.16.
//  Copyright © 2016 Dan Cech. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class RegistrationViewController: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var useCreditCardSwitch: UISwitch!
    @IBOutlet weak var creditCardTextField: UITextField!
    @IBOutlet weak var cardStatusLabel: UILabel!
    @IBOutlet weak var verifyCardButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var registerButton: UIButton!
    
    var viewModel: RegistrationViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = RegistrationViewModel()
        
        initViewModelBindings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func initViewModelBindings()
    {
        emailTextField.reactive.continuousTextValues.skipNil().observeValues { email in
            print(email)
        }
        
        viewModel.email <~ emailTextField.reactive.continuousTextValues.skipNil()
        viewModel.password <~ passwordTextField.reactive.continuousTextValues.skipNil()
        viewModel.passwordAgain <~ passwordAgainTextField.reactive.continuousTextValues.skipNil()
        viewModel.useCreditCard <~ useCreditCardSwitch.reactive.isOnValues
        viewModel.creditCardNumber <~ creditCardTextField.reactive.continuousTextValues.skipNil()
        
//        cardStatusLabel.rac_text <~ viewModel.cardStatus

        viewModel.initBindings()
        
        registerButton.reactive.isEnabled <~ viewModel.correctInputProducer
        
        viewModel.correctEmailProducer.startWithValues { (correct) in
            self.emailTextField.textColor = correct ? UIColor.blue : UIColor.gray
        }
        
        viewModel.correctPasswordProducer.startWithValues { (correct) -> () in
            let backgroundColor = correct ? UIColor.lightGray : UIColor.red
            self.passwordTextField.textColor = backgroundColor
            self.passwordAgainTextField.textColor = backgroundColor
        }
        
        viewModel.useCreditCard.producer.startWithValues { (useCard) -> () in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
        viewModel.cardStatus.producer.startWithValues { (status) -> () in
            switch status {
                
            case .notVerified:
                self.cardStatusLabel.text = "Card has not been verified yet"
                self.activityIndicator.isHidden = true
                self.verifyCardButton.isHidden = false
                
            case .verifying:
                self.cardStatusLabel.text = "Card is currently being verified"
                self.activityIndicator.isHidden = false
                self.verifyCardButton.isHidden = true
            
            case .verified:
                self.cardStatusLabel.text = "Card is verified"
                self.activityIndicator.isHidden = true
                self.verifyCardButton.isHidden = true
                
            case .denied:
                self.cardStatusLabel.text = "Card is denied"
                self.activityIndicator.isHidden = true
                self.verifyCardButton.isHidden = false
                
            }
            
        }
    }
    
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - TableView
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 4) || (indexPath.row == 5) {
            if viewModel.useCreditCard.value {
                return 44
            }
            else {
                return 0
            }
        }
        
        return 44
    }
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowSummary" {
            let summaryController = segue.destination as! SummaryViewController
            summaryController.viewModel = viewModel.createSummaryViewModel()
        }
    }
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Actions
    
    @IBAction func showSummary(_ sender: AnyObject) {
        performSegue(withIdentifier: "ShowSummary", sender: self)
    }

    @IBAction func verifyCardNumber(_ sender: AnyObject) {
        viewModel.verifyCardNumber()
    }
}
