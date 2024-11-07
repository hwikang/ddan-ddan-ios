//
//  AppCoordinator.swift
//  DDanDDan
//
//  Created by 이지희 on 11/7/24.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    // 네비게이션 경로를 저장하는 프로퍼티
    @Published var navigationPath = NavigationPath()
    // 시트를 표시하기 위한 뷰를 저장하는 프로퍼티
    @Published var sheetView: AnyView?
    
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
        navigationPath.append(path)
    }
    
    func push(to path: SettingPath) {
        navigationPath.append(path)
    }
    
    func push(to path: HomePath) {
        navigationPath.append(path)
    }
}
