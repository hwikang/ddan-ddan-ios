//
//  DDanDDanApp.swift
//  DDanDDan
//
//  Created by paytalab on 6/28/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct DDanDDanApp: App {
    init() {
        KakaoSDK.initSDK(appKey: "87ce44f4ab5c4efbff8e1db25c007bbe")
    }
    var body: some Scene {
        
        WindowGroup {
            if UserDefaultValue.acessToken != nil {
                //TODO: 메인 연결
            } else if UserDefaultValue.needToShowOnboarding {
                OnboardingView()
            } else {
                SignUpView()
            }
            
        }
    }
}
