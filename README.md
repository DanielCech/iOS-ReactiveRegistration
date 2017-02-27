# iOS-ReactiveRegistration

Sample of Reactive Cocoa 5 & MVVM

This projects implements the simple registration screen. You can proceed the registration only if the form is correctly filled in. It is necessary to enter correct email. Enter the same password to the "Password" and "Password again" fields. Password should be more than 5 characters long. You can decide whether to use credit card. If you dedice to use credit card, you must first enter the card number and then verify it. Button "Verify" starts the fake network request. Only card number "123456" is considered to be valid.

Project demonstrates using of Reactive Cocoa 5 in Swift 3, UI bindings and the separation of controller and view model.

Compare this solution with [Allan Barbato's](https://github.com/allbto/iOS-DynamicRegistration) non-reactive implementation of the same project using lightweight MVVM binding provided by [Swiftility](https://github.com/allbto/iOS-Swiftility) library.

