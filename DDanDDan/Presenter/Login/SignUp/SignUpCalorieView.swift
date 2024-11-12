//
//  SignUpCalorieView.swift
//  DDanDDan
//
//  Created by hwikang on 8/24/24.
//

import SwiftUI

struct SignUpCalorieView: View {
    public let viewModel: SignUpViewModelProtocol
    @State private var calorie: Int = 100
    @ObservedObject var coordinator: AppCoordinator
    
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
                        //TODO: 실패처리
                        await viewModel.updateCalorie(calorie: calorie)
                        coordinator.push(to: .nickname)
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
    SignUpCalorieView(viewModel: SignUpViewModel(repository: SignUpRepository()), coordinator: AppCoordinator())
}
