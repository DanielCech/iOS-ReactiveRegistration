//
//  Util.swift
//  ReactiveTwitterSearch
//
//  Created by Colin Eberhardt on 10/05/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import UIKit
import ReactiveSwift

struct AssociationKey {
    static var hidden: UInt8 = 1
    static var alpha: UInt8 = 2
    static var text: UInt8 = 3
    static var image: UInt8 = 4
    static var on: UInt8 = 5
    static var enabled: UInt8 = 6
}

// lazily creates a gettable associated property via the given factory
func lazyAssociatedProperty<T: AnyObject>(_ host: AnyObject, key: UnsafeRawPointer, factory: ()->T) -> T {
    var associatedProperty = objc_getAssociatedObject(host, key) as? T
    
    if associatedProperty == nil {
        associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    return associatedProperty!
}

func lazyMutableProperty<T>(_ host: AnyObject, key: UnsafeRawPointer, setter: @escaping (T) -> (), getter: @escaping () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key: key) {
        let property = MutableProperty<T>(getter())
        property.producer
            .startWithValues { newValue in
                setter(newValue)
        }
        return property
    }
}

extension UIView {
    public var rac_alpha: MutableProperty<CGFloat> {
        return lazyMutableProperty(self, key: &AssociationKey.alpha, setter: { self.alpha = $0 }, getter: { self.alpha  })
    }
    
    public var rac_hidden: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.hidden, setter: { self.isHidden = $0 }, getter: { self.isHidden  })
    }
}

extension UIImageView {
    public var rac_image: MutableProperty<UIImage?> {
        return lazyMutableProperty(self, key: &AssociationKey.image, setter: { self.image = $0 }, getter: { self.image })
    }
}

extension UILabel {
    public var rac_text: MutableProperty<String> {
        return lazyMutableProperty(self, key: &AssociationKey.text, setter: { self.text = $0 }, getter: { self.text ?? "" })
    }
}

extension UITextField {
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(self, key: &AssociationKey.text) {
            
            self.addTarget(self, action: #selector(UITextField.changed), for: UIControlEvents.editingChanged)
            
            let property = MutableProperty<String>(self.text ?? "")
            property.producer
                .startWithValues { newValue in
                    self.text = newValue
            }
            return property
        }
    }
    
    func changed() {
        rac_text.value = self.text!
    }
}

extension UISearchBar: UISearchBarDelegate {
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(self, key: &AssociationKey.text) {
            
            self.delegate = self
            
            let property = MutableProperty<String>(self.text ?? "")
            property.producer
                .startWithValues { newValue in
                    self.text = newValue
            }
            return property
        }
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        rac_text.value = searchBar.text!
    }
}

extension UISwitch {
    public var rac_on: MutableProperty<Bool> {
        return lazyAssociatedProperty(self, key: &AssociationKey.on) {
            
            self.addTarget(self, action: #selector(UISwitch.changed), for: UIControlEvents.valueChanged)
            
            let property = MutableProperty<Bool>(self.isOn)
            property.producer
                .startWithValues { newValue in
                    self.isOn = newValue
            }
            return property
        }
    }
    
    func changed() {
        rac_on.value = self.isOn
    }
}

extension UIButton {
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.enabled, setter: { self.isEnabled = $0 }, getter: { self.isEnabled })
    }
}

