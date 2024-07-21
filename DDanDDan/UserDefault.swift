//
//  UserDefault.swift
//  DDanDDan
//
//  Created by paytalab on 7/21/24.
//

import Foundation

public struct UserDefaultValue {
    @UserDefault(key: "requestAuthDone", defaultValue: false)
    static public var requestAuthDone: Bool
}

@propertyWrapper
public struct UserDefault<T> {
    public let key: String
    let defaultValue: T
    
    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
