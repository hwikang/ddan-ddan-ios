//
//  SignUpSuccessView.swift
//  DDanDDan
//
//  Created by hwikang on 8/26/24.
//

import SwiftUI

struct SignUpSuccessView: View {
    public let viewModel: SignUpViewModelProtocol
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("딴딴에 가입하신 것을\n환영해요!")
                    .font(.system(size: 24, weight: .bold))
                    .lineSpacing(8)
                    .foregroundStyle(.white)
                    .padding(.top, 80)
                    .padding(.horizontal, 20)
                HStack(alignment: .center) {
                    Image("signUpSuccess")
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 64)
                Spacer()
                
                GreenButton(action: {
                    coordinator.popToRoot()
                    Task {
                        await viewModel.login()
                    }
                }, title: "시작하기", disabled: .constant(false))
            }
        }
    }
}

#Preview {
    SignUpSuccessView(viewModel: SignUpViewModel(repository: SignUpRepository()), coordinator: AppCoordinator())
}
