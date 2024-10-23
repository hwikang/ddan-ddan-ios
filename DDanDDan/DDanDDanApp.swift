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
                //TODO: 메인 연결
                
            } else if UserDefaultValue.needToShowOnboarding {
                OnboardingView()
            } else {
                SignUpView()
            }
            
        }
    }
}
