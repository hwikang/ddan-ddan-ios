//
//  SignUpCalorieView.swift
//  DDanDDan
//
//  Created by paytalab on 8/24/24.
//

import SwiftUI

struct SignUpCalorieView: View {
    private let viewModel: SignUpCalorieViewModel
    @State private var signUpData: SignUpData
    @State private var calorie: Int = 100
    @State private var nextButtonTapped: Bool = false
    
    public init(signUpData: SignUpData, viewModel: SignUpCalorieViewModel) {
        self.signUpData = signUpData
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    Text("하루 목표 칼로리를\n설정해주세요")
                        .font(.system(size: 24, weight: .bold))
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
                            .foregroundStyle(Color(red: 19/255, green: 230/255, blue: 149/255))
                            .frame(width: 84, height: 80)
                            .background(Color(red: 33/255, green: 33/255, blue: 33/255))
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
                                nextButtonTapped = true
                            }
                        }
                    }, title: "다음", disabled: .constant(false))
                }
            }
            .navigationDestination(isPresented: $nextButtonTapped) {
                SignUpSuccessView()
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
    SignUpCalorieView(signUpData: .init(), viewModel: .init())
}
