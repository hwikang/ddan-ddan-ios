//
//  UserManager.swift
//  DDanDDan
//
//  Created by hwikang on 10/14/24.
//

import Foundation

actor UserManager: ObservableObject {
    static let shared = UserManager()
    
    @MainActor @Published var accessToken: String? = UserDefaultValue.acessToken
    private var userData: UserData?
    @MainActor public var kakaoToken: String?
    @MainActor public var appleToken: String?
    private var refreshToken: String? = UserDefaultValue.refreshToken
    @MainActor private var isOnboardingComplete: Bool = UserDefaultValue.isOnboardingComplete

    private init() {
        
    }
    
    func setUserData(_ data: UserData) {
        self.userData = data
    }

    func getUserData() -> UserData? {
        return self.userData
    }
    
    func setToken(accessToken: String, refreshToken: String) async {
        self.refreshToken = refreshToken
        await MainActor.run {
            self.accessToken = accessToken
           
        }
    }
    
    @MainActor
    func isSignUpRequired() -> Bool {
        !isOnboardingComplete
    }
    
    func login(loginData: LoginData) async {
        refreshToken = loginData.refreshToken
        userData = loginData.user
        UserDefaultValue.acessToken = loginData.accessToken
        UserDefaultValue.refreshToken = loginData.refreshToken
        UserDefaultValue.isOnboardingComplete = loginData.isOnboardingComplete
        await MainActor.run {
            isOnboardingComplete = loginData.isOnboardingComplete
            accessToken = loginData.accessToken
           
        }
    }
    func logout() async {
        userData = nil
        refreshToken = nil
        await MainActor.run {
            accessToken = nil
        }
       
    }
}
