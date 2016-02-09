//
//  RegistrationViewController.swift
//  ReactiveRegistration
//
//  Created by Dan on 09.02.16.
//  Copyright © 2016 Dan Cech. All rights reserved.
//

import UIKit
import ReactiveCocoa

class RegistrationViewController: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var useCreditCardSwitch: UISwitch!
    @IBOutlet weak var creditCardTextField: UITextField!
    @IBOutlet weak var cardStatusLabel: UILabel!
    @IBOutlet weak var verifyCardButton: UIButton!
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
        viewModel.email = emailTextField.rac_text
        viewModel.password = passwordTextField.rac_text
        viewModel.passwordAgain = passwordAgainTextField.rac_text
        viewModel.useCreditCard = useCreditCardSwitch.rac_on
        viewModel.creditCardNumber = creditCardTextField.rac_text
        
//        cardStatusLabel.rac_text <~ viewModel.cardStatus

        viewModel.initBindings()
        
        registerButton.rac_enabled <~ viewModel.correctInputProducer
        
        viewModel.correctPasswordProducer.startWithNext { (correct) -> () in
            let backgroundColor = correct ? UIColor.lightGrayColor() : UIColor.redColor()
            self.passwordTextField.textColor = backgroundColor
            self.passwordAgainTextField.textColor = backgroundColor
        }
        
        viewModel.useCreditCard.producer.startWithNext { (useCard) -> () in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - TableView
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "ShowSummary" {
            let summaryController = segue.destinationViewController as! SummaryViewController
            summaryController.viewModel = viewModel.createSummaryViewModel()
        }
    }
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Actions
    
    @IBAction func showSummary(sender: AnyObject) {
        performSegueWithIdentifier("ShowSummary", sender: self)
    }

}
