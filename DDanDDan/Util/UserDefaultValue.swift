//
//  UserDefault.swift
//  DDanDDan
//
//  Created by hwikang on 7/21/24.
//

import Foundation

public struct UserDefaultValue {
    //Auth
    @UserDefault(key: "acessToken", defaultValue: nil)
    static public var acessToken: String?  
    @UserDefault(key: "refreshToken", defaultValue: nil)
    static public var refreshToken: String?
    
    @UserDefault(key: "requestAuthDone", defaultValue: false)
    static public var requestAuthDone: Bool
    @UserDefault(key: "needToShowOnboarding", defaultValue: true)
    static public var needToShowOnboarding: Bool

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
