//
//  SuccessView.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI

struct LevelUpView: View {
    @ObservedObject var coordinator: AppCoordinator
    private let level: Int
    
    init(coordinator: AppCoordinator, level: Int) {
        self.coordinator = coordinator
        self.level = level
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.backgroundBlack)
            VStack {
                Spacer()
                imageView
                Text("lv.\(level)로\n업그레이드 되었어요!")
                    .multilineTextAlignment(.center)
                    .font(.neoDunggeunmo24)
                    .foregroundStyle(.white)
                    .padding(.vertical, 32)
                Spacer()
                GreenButton(action: {
                    print("click")
                }, title: "성장하기", disabled: .constant(false))
                .padding(.bottom, 44)
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    var imageView: some View {
        ZStack {
            Image(.pangGraphics)
            Image(.blueLv3)
                .offset(y: 18)
        }
    }
}

#Preview {
    LevelUpView(coordinator: .init(), level: 1)
}
