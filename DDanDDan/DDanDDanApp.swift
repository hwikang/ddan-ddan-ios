//
//  DDanDDanApp.swift
//  DDanDDan
//
//  Created by hwikang on 6/28/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct DDanDDanApp: App {
    @StateObject var user = UserManager.shared
    init() {
        KakaoSDK.initSDK(appKey: "87ce44f4ab5c4efbff8e1db25c007bbe")
    }
    var body: some Scene {
        
        WindowGroup {
            
            if user.accessToken != nil {
              
                if user.isSignUpRequired() {
                    SignUpTermView(viewModel: SignUpViewModel(repository: SignUpRepository()))
                } else {
                    HomeView(viewModel: HomeViewModel(repository: HomeRepository()))
                }
            } else {
                if UserDefaultValue.needToShowOnboarding {
                    OnboardingView()
                } else {
                    LoginView(viewModel: LoginViewModel(repository: LoginRepository()))
                }
            }
            
        }
    }
}

