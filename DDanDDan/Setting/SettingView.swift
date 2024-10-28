//
//  SettingView.swift
//  DDanDDan
//
//  Created by hwikang on 9/10/24.
//

import SwiftUI

enum SettingPath: Hashable, CaseIterable {
    static var allCases: [SettingPath] {
        [.updateNickname, .updateCalorie, .notification, .updateTerms, .deleteUser, .logout]
    }
    
    case updateNickname
    case updateCalorie
    case notification
    case updateTerms
    case deleteUser
    case deleteUserConfirm(reasons: Set<String>)
    case logout
    
    var description: String {
        switch self {
        case .updateNickname: "내 별명 수정"
        case .updateCalorie: "목표 칼로리 수정"
        case .notification: "푸시 알림"
        case .updateTerms: "약관 및 개인정보 처리 동의"
        case .deleteUser: "탈퇴하기"
        case .logout: "로그아웃"
        default: ""
        }
    }
}

struct SettingView: View {
    @State public var path: [SettingPath] = []
    @State private var notificationState = true
    @State private var showLogoutDialog = false

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.backgroundBlack
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
               
                Color.backgroundGray.edgesIgnoringSafeArea(.all)
                
                List(SettingPath.allCases, id: \.self) { item in
                    HStack(alignment: .firstTextBaseline) {
                        switch item {
                        case .notification:
                            Text(item.description)
                        case .logout:
                            Button(item.description) {
                                showLogoutDialog.toggle()
                            }
                        default:
                            Button(item.description) {
                                path.append(item)
                            }
                        }
                        Spacer()
                        if item == .notification {
                            Toggle("", isOn: $notificationState).labelsHidden()
                        } else {
                            Image(systemName: "chevron.right").foregroundColor(.white)
                        }
                    }
                    .foregroundStyle(.white)
                    .listRowBackground(Color.backgroundBlack)
                }
                .navigationDestination(for: SettingPath.self, destination: { type in
                    getDestination(type: type)
                })
                .fullScreenCover(isPresented: $showLogoutDialog) {
                    DialogView(show: $showLogoutDialog, title: "정말 로그아웃 하시겠습니까", description: "", rightButtonTitle: "로그아웃", leftButtonTitle: "취소") {
                        Task {
                            await UserManager.shared.logout()
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listStyle(.plain)
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private func getDestination(type: SettingPath) -> some View {
        switch type {
        case .updateNickname:
            UpdateNicknameView(viewModel: UpdateNicknameViewModel(nickname: "", repository: SettingRepository()), path: $path)
        case .updateCalorie:
            UpdateCalorieView(viewModel: UpdateCalorieViewModel(calorie: 100, repository: SettingRepository()), path: $path)
        case .updateTerms:
            SettingTermView()
        case .deleteUser:
            DeleteUserView(path: $path)
        case .deleteUserConfirm(let reasons):
            DeleteUserConfirmView(viewModel: DeleteUserViewModel(), path: $path, selectedReason: reasons)
        default:
            EmptyView()
        }
    }
}

#Preview {
    SettingView()
}
