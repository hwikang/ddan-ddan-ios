//
//  SettingView.swift
//  DDanDDan
//
//  Created by paytalab on 9/10/24.
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
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
    }
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
               
                Color.backgorundGray.edgesIgnoringSafeArea(.all)
                
                List(SettingPath.allCases, id: \.self) { item in
                    HStack(alignment: .firstTextBaseline) {
                        if item != .notification {
                            Text(item.description)
                                .background(NavigationLink("", destination: DetailView(item: "\(item)")).opacity(0))
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
                
                .listRowSeparator(.hidden)
                .listStyle(.plain)
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
        }
       
    }
}

struct DetailView: View {
    let item: String
    
    var body: some View {
        Text("You selected \(item)")
            .font(.largeTitle)
            .navigationTitle(item)
    }
}

#Preview {
    SettingView()
}
