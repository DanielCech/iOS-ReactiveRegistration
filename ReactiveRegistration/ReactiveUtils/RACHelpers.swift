//
//  RACHelpers.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import ReactiveSwift
import enum Result.NoError

public typealias NoError = Result.NoError

extension SignalProducer where Value: OptionalProtocol {
	public func ignoreError() -> SignalProducer<Value, NoError> {
		return flatMapError { _ in
            SignalProducer<Value, NoError>.empty
        }
	}
}

public func merge<T, E>(_ signals: [SignalProducer<T, E>]) -> SignalProducer<T, E> {
    return SignalProducer<SignalProducer<T, E>, E>(signals).flatten(.merge)
}

