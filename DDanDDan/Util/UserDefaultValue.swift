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
    
    @UserDefault(key: "isOnboardingComplete", defaultValue: false)
    static public var isOnboardingComplete: Bool
    @UserDefault(key: "requestAuthDone", defaultValue: false)
    static public var requestAuthDone: Bool
    @UserDefault(key: "needToShowOnboarding", defaultValue: true)
    static public var needToShowOnboarding: Bool
    
    // Main
    @UserDefault(key: "purposeKcal", defaultValue: 0)
    static public var purposeKcal: Int
    @UserDefault(key: "userId", defaultValue: "")
    static public var userId: String
    @UserDefault(key: "petId", defaultValue: "")
    static public var petId: String
    
    @UserDefault(key: "petType", defaultValue: "DOG")
    static public var petType: String
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
