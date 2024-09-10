//
//  SignUpView.swift
//  DDanDDan
//
//  Created by paytalab on 7/21/24.
//

import SwiftUI
import KakaoSDKUser
import KakaoSDKCommon

public enum SignUpPath: Hashable {
    case term
    case egg
    case nickname
    case calorie
    case success
    case main
}

struct SignUpView: View {
    @State public var signUpData = SignUpData()
    @State private var path: [SignUpPath] = []
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 280, height: 280)
                    Spacer()
                    Button {
                        if UserApi.isKakaoTalkLoginAvailable() {
                            UserApi.shared.loginWithKakaoTalk(serviceTerms: []) { token, error in
                                if let error = error { 
                                    print(error)
                                    return
                                }
                                getKakaoUser()
                            }
                        } else {
                            UserApi.shared.loginWithKakaoAccount(serviceTerms: []) { token, error in
                                if let error = error {
                                    print(error)
                                    return
                                }
                                getKakaoUser()
                            }
                        }
                        
                    } label: {
                        Text("카카오톡으로 시작하기")
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .background(Color(red: 254/255, green: 229/255, blue: 0/255))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom)
                .navigationDestination(for: SignUpPath.self) { path in
                    switch path {
                    case .term:    SignUpTermView(signUpData: signUpData, path: $path)
                    case .egg:  SignUpEggView(signUpData: signUpData, path: $path)
                    case .nickname:  SignUpNicknameView(signUpData: signUpData, path: $path)
                    case .calorie:  SignUpCalorieView(signUpData: signUpData, path: $path)
                    case .success:  SignUpSuccessView(path: $path)
                    case .main: SettingView()
                    }
                    
                }
                
            }
        }
    }
    
    private func getKakaoUser() {
        UserApi.shared.me() { user, error in
            if let error = error {
                print(error)
                return
            }
            signUpData.kakaoUser = user
            path.append(.term)
        }
    }
}

#Preview {
    SignUpView()
}
