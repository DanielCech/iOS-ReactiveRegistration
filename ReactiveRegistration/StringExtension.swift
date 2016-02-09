//
//  RegistrationViewController.swift
//  ReactiveRegistration
//
//  Created by Dan on 09.02.16.
//  Copyright © 2016 Dan Cech. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }

}
