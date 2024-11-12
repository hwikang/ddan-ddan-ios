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
    @StateObject private var appCoordinator = AppCoordinator()
    
    init() {
        KakaoSDK.initSDK(appKey: "87ce44f4ab5c4efbff8e1db25c007bbe")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appCoordinator)
        }
    }
}

struct ContentView: View {
    @StateObject var user = UserManager.shared
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var homeViewModel = HomeViewModel(repository: HomeRepository())
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            if user.accessToken != nil {
                if user.isSignUpRequired() {
                    SignUpTermView(viewModel: SignUpViewModel(repository: SignUpRepository()), coordinator: coordinator)
                } else {
                    HomeView(viewModel: homeViewModel, coordinator: coordinator)
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
