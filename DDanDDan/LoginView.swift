//
//  SignUpView.swift
//  DDanDDan
//
//  Created by hwikang on 7/21/24.
//

import SwiftUI
import KakaoSDKUser
import KakaoSDKCommon

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    var body: some View {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 280, height: 280)
                    Spacer()
                    Button {
                        viewModel.kakaoLogin()
                        
                    } label: {
                        Text("카카오톡으로 시작하기")
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .background(Color(red: 254/255, green: 229/255, blue: 0/255))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom)
            }
    }
    
}

#Preview {
    LoginView(viewModel: LoginViewModel(repository: LoginRepository()))
}
