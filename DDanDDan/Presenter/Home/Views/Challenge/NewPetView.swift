//
//  NewPetView.swift
//  DDanDDan
//
//  Created by 이지희 on 11/20/24.
//

import SwiftUI

struct NewPetView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.backgroundBlack)
            VStack {
                Spacer()
                imageView
                Text("새로운 펫을\n키울 수 있어요!")
                    .multilineTextAlignment(.center)
                    .font(.neoDunggeunmo24)
                    .foregroundStyle(.white)
                    .padding(.vertical, 32)
                Spacer()
                GreenButton(action: {
                    coordinator.pop()
                }, title: "시작하기", disabled: .constant(false))
                .padding(.bottom, 44)
            }
        }
        .ignoresSafeArea()
    }
    
    var imageView: some View {
        ZStack {
            Image(.pangGraphics)
            Image(.eggBlue)
                .offset(y: 18)
        }
    }
}

#Preview {
    NewPetView(coordinator: .init())
}
