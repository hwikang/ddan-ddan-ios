//
//  AppCoordinator.swift
//  DDanDDan
//
//  Created by 이지희 on 11/7/24.
//

import SwiftUI

enum AppPath: Hashable {
    case splash
    case signUp
    case home
    case onboarding
    case login
}

final class AppCoordinator: ObservableObject {
    // 루트뷰
    @Published var rootView: AppPath = .splash
    
    // 스플래쉬에서 미리 받을 정보
    @Published var userInfo: HomeUserInfo? = nil
    @Published var petInfo: MainPet? = nil
    
    // 네비게이션 경로를 저장하는 프로퍼티
    @Published var navigationPath = NavigationPath()
    // 시트를 표시하기 위한 뷰를 저장하는 프로퍼티
    @Published var sheetView: AnyView?
    
    func setRoot(to path: AppPath) {
        rootView = path
    }
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func presentSheet<View: SwiftUI.View>(view: View) {
        sheetView = AnyView(view)
    }
    
    func push(to path: SignUpPath) {
        print("push: \(path)")
        navigationPath.append(path)
    }
    
    func push(to path: SettingPath) {
        print("push: \(path)")
        navigationPath.append(path)
    }
    
    func push(to path: HomePath) {
        print("push: \(path)")
        navigationPath.append(path)
    }
}
