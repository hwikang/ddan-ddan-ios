//
//  SignUpCalorieView.swift
//  DDanDDan
//
//  Created by hwikang on 8/24/24.
//

import SwiftUI

struct SignUpCalorieView: View {
    private let viewModel: SignUpCalorieViewModel = SignUpCalorieViewModel()
    @State public var signUpData: SignUpData
    @State private var calorie: Int = 100
    @Binding public var path: [SignUpPath]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("하루 목표 칼로리를\n설정해주세요")
                    .font(.neoDunggeunmo24)
                    .lineSpacing(8)
                    .foregroundStyle(.white)
                    .padding(.top, 80)
                    .padding(.horizontal, 20)
                HStack(alignment: .center) {
                    
                    Button {
                        increaseCalorie()
                    } label: {
                        Image("plusButtonRounded")
                    }
                    Text(String(calorie))
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundStyle(.buttonGreen)
                        .frame(width: 84, height: 80)
                        .background(.backgroundGray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Button {
                        decreaseCalorie()
                    } label: {
                        Image("minusButtonRounded")
                    }
                    
                }.frame(maxWidth: .infinity)
                    .padding(.top, 56)
                
                Spacer()
                
                GreenButton(action: {
                    Task {
                        if await viewModel.signUp(signupData: signUpData) {
                            if await viewModel.login() {
                                path.append(.success)
                                
                            }
                        }
                    }
                }, title: "다음", disabled: .constant(false))
            }
            
        }
    }
    
    private func increaseCalorie() {
        guard calorie < 1000 else { return }
        calorie += 100
    }
    
    private func decreaseCalorie() {
        guard calorie > 100 else { return }
        calorie -= 100
    }
}

#Preview {
    SignUpCalorieView(signUpData: .init(), path: .constant([]))
}
