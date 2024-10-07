//
//  SettingView.swift
//  DDanDDan
//
//  Created by hwikang on 9/10/24.
//

import SwiftUI

enum SettingPath: Hashable, CaseIterable {
    case updateNickname
    case updateCalorie
    case notification
    case updateTerms
    case deleteUser
    case logout
    
    var description: String {
        switch self {
        case .updateNickname: "내 별명 수정"
        case .updateCalorie: "목표 칼로리 수정"
        case .notification: "푸시 알림"
        case .updateTerms: "약관 및 개인정보 처리 동의"
        case .deleteUser: "탈퇴하기"
        case .logout: "로그아웃"
        }
    }
}

struct SettingView: View {
    @State public var path: [SettingPath] = []
    @State private var notificationState = true
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
                        if item != .notification {
                            Button(item.description) {
                                path.append(item)
                            }
                        } else {
                            Text(item.description)
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
            UpdateNicknameView(viewModel: UpdateNicknameViewModel(nickname: ""), path: $path)
        case .updateCalorie:
            UpdateCalorieView(viewModel: UpdateCalorieViewModel(calorie: 100), path: $path)
        case .updateTerms:
            SettingTermView()
        case .deleteUser:
            DeleteUserView(viewModel: DeleteUserViewModel())
        default:
            UpdateNicknameView(viewModel: UpdateNicknameViewModel(nickname: ""), path: $path)
        }
    }
}

#Preview {
    SettingView()
}
