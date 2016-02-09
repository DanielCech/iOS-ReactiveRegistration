//
//  SummaryViewController.swift
//  ReactiveRegistration
//
//  Created by Dan on 09.02.16.
//  Copyright © 2016 Dan Cech. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var creditCardNumberLabel: UILabel!
    
    
    var viewModel: SummaryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        emailLabel.text = viewModel.email
        creditCardNumberLabel.text = viewModel.creditCardNumber ?? "<N/A>"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
