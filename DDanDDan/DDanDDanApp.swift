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
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject var user = UserManager.shared
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            switch coordinator.rootView {
            case .splash:
                SplashView(viewModel: SplashViewModel(coordinator: coordinator, homeRepository: HomeRepository()))
            case .signUp:
                SignUpTermView(viewModel: SignUpViewModel(repository: SignUpRepository()), coordinator: coordinator)
            case .home:
                HomeView(repository: HomeRepository(), coordinator: coordinator)
            case .onboarding:
                OnboardingView()
            case .login:
                LoginView(viewModel: LoginViewModel(repository: LoginRepository()))
            }
        }
    }
}

