//
//  SignUpNicknameView.swift
//  DDanDDan
//
//  Created by paytalab on 8/20/24.
//

import SwiftUI

struct SignUpNicknameView: View {
    @State private var buttonDisabled: Bool = true
    @State public var signUpData: SignUpData
    @State private var nickname: String = ""
    @Binding public var path: [SignUpPath]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    
                    Text("별명을 알려주세요")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.top, 80)
                    
                    Text("별명")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.gray)
                        .padding(.top, 10)
                    TextField("별명을 입력해주세요", text: $nickname)
                        .padding()
                        .background(.backgroundGray)
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .cornerRadius(8)
                        .border(.secondary)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                GreenButton(action: {
                    signUpData.nickname = nickname
                    path.append(.calorie)
                    print("signUpData \(signUpData)")
                }, title: "다음", disabled: $buttonDisabled)
                .onChange(of: nickname) { newValue in
                    buttonDisabled = nickname.isEmpty
                }
            }
         
        }
    }
}

#Preview {
    SignUpNicknameView(signUpData: .init(), path: .constant([]))
}
