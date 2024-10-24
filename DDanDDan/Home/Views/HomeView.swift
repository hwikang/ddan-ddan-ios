//
//  HomeView.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {  // 최상단에서 NavigationView로 감쌈
            ZStack {
                Color(.backgroundBlack)
                    .ignoresSafeArea()
                VStack {
                    navigationBar
                        .padding(.bottom, 16)
                    kcalView
                        .padding(.bottom, 14)
                    ZStack {
                        viewModel.backgroundImage()
                            .scaledToFit()
                            .padding(.horizontal, 53)
                            .clipped()
                        viewModel.characterImage()
                            .scaledToFit()
                            .padding(.horizontal, 141)
                            .offset(y: 100)
                    }
                    .padding(.bottom, 32)
                    levelView
                        .padding(.bottom, 20)
                    actionButtonView
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .onAppear {
                /// 권한을 받지 않았을 경우 권한 받기 필요
                HealthKitManager.shared.requestAuthorization { auth in
                    print("HealthKit auth: \(auth)")
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    /// 네비게이션 바
    var navigationBar: some View {
        HStack {
            NavigationLink(destination: PetArchiveView()) {
                Image(.iconDocs)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            Button {
                print("설정 클릭됨")
            } label: {
                Image(.iconSetting)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 20)
        }
    }
    
    var kcalView: some View {
        HStack(spacing: 4) {
            Text("\(viewModel.currentKcalModel.currentKcal)")
                .font(.neoDunggeunmo52)
                .foregroundStyle(.white)
            Text("/")
                .font(.neoDunggeunmo42)
                .foregroundStyle(.white)
            Text("\(viewModel.homePetModel.goalKcal) kcal")
                .font(.neoDunggeunmo22)
                .foregroundStyle(.white)
        }
    }
    
    /// 레벨 정보 뷰
    var levelView: some View {
        VStack {
            HStack {
                Text("Lv.\(viewModel.homePetModel.level)")
                    .font(.neoDunggeunmo14)
                    .padding(4)
                    .foregroundStyle(.white)
                    .background(.borderGray)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity,alignment: .leading)
                let percentage = Double(viewModel.currentKcalModel.currentKcal) / Double(viewModel.homePetModel.goalKcal) * 100
                Text(String(format: "%.0f%%", percentage))
                    .font(.subTitle1_semibold16)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity,alignment: .trailing)
            }
            Image(.gaugeBackground)
                .resizable()
                .frame(height: 28)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
    }
    
    /// 액션 버튼 뷰
    var actionButtonView: some View {
        HStack(spacing: 12) {
            HomeButton(buttonTitle: "먹이주기", count: viewModel.homePetModel.feedCount)
            HomeButton(buttonTitle: "놀아주기", count: viewModel.homePetModel.toyCount)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 66)
        .padding(.horizontal, 32)
    }
}

//#Preview {
//  HomeView(viewModel: HomeViewModel(model: HomeModel(petType: .purpleDog, goalKcal: 200, currentKcal: 50, level: 4, feedCount: 3, toyCount: 2)))
//}
