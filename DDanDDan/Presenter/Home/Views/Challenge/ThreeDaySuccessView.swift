//
//  LevelUpView.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI

struct ThreeDaySuccessView: View {
    @ObservedObject var coordinator: AppCoordinator
    var totalKcal: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.backgroundBlack)
            VStack {
                Text("3일 내내 운동을\n열심히 하셨네요!")
                    .multilineTextAlignment(.center)
                    .font(.neoDunggeunmo24)
                    .foregroundStyle(.white)
                    .padding(.top, 124)
                    .padding(.bottom, 80)
                
                VStack(spacing: 16) {
                    listComponentView(
                        image: Image(.kcalGraphic),
                        title: "3일간 소모한 칼로리",
                        content: "\(totalKcal)kcal"
                    )
                    listComponentView(
                        image: Image(.luckyGraphic),
                        title: "받은 장난감",
                        content: "행운의 풀떼기 1개"
                    )
                }
                Spacer()
                GreenButton(action: {
                    coordinator.pop()
                }, title: "획득하기", disabled: .constant(false))
                .padding(.bottom, 44)
            }
        }
        .ignoresSafeArea()
    }
    /// 리스트 컴포넌트 뷰
    func listComponentView(image: Image, title: String, content: String) -> some View {
        ZStack(alignment: .leading) {
            Color(.borderGray)
                .cornerRadius(8)
            HStack {
                image
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.heading5_semibold18)
                        .foregroundStyle(.textHeadlinePrimary)
                    Text("\(content)")
                        .font(.subTitle1_semibold16)
                        .foregroundStyle(.textBodyTeritary)
                }
            }
            .padding(.horizontal,20)
        }
        .frame(height: 80)
    }
}

#Preview {
    ThreeDaySuccessView(coordinator: .init(), totalKcal: 0)
}
