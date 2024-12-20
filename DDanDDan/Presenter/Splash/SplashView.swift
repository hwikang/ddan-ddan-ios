//
//  SplashView.swift
//  DDanDDan
//
//  Created by 이지희 on 11/19/24.
//

import SwiftUI

struct SplashView: View {
    @StateObject var viewModel: SplashViewModel
    
    var body: some View {
        ZStack {
            Color(.backgroundBlack)
                .ignoresSafeArea(.all)
            VStack(alignment: .center) {
                Spacer()
                Image(.splashLogo)
                Spacer()
                Image(.splashStart)
            }
        }
        .onAppear {
            viewModel.navigateToNextScreen()
        }
    }
}
