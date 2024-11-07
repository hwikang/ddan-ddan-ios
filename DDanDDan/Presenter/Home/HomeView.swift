//
//  HomeView.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI
import HealthKit

enum HomePath: Hashable {
    case setting
    case petArchive
    case achieveGoalKcal
    case earnFeed
    case eranThreeDay
    case newPet
    case upgradePet
}

struct HomeView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject var viewModel: HomeViewModel
    
    @State private var showImageDialog = false
    
    init(viewModel: HomeViewModel, coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel) 
    }
    
    var body: some View {
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
        .navigationDestination(for: HomePath.self) { path in
            switch path {
            case .achieveGoalKcal:
                SuccessView()
            case .setting:
                SettingView(coordinator: coordinator)
            case .petArchive:
                PetArchiveView(viewModel: PetArchiveViewModel(repository: HomeRepository()), coordinator: coordinator)
            case .earnFeed, .eranThreeDay, .newPet:
                EmptyView()
            case .upgradePet:
                LevelUpView()
            }
        }
        .navigationBarHidden(true)
    }
}

extension HomeView {
    /// 네비게이션 바
    var navigationBar: some View {
        HStack {
            Button(action: {
                coordinator.push(to: .petArchive)
            }) {
                Image(.iconDocs)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            Button(action: {
                coordinator.push(to: .setting)
            }) {
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
    
    var levelView: some View {
        VStack {
            HStack {
                Text("Lv.\(viewModel.homePetModel.level)")
                    .font(.neoDunggeunmo14)
                    .padding(4)
                    .foregroundStyle(.white)
                    .background(.borderGray)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                let adjustedGoalKcal = max(Double(viewModel.homePetModel.goalKcal), 1)
                let percentage = Double(viewModel.currentKcalModel.currentKcal) / adjustedGoalKcal * 100
                
                Text(String(format: "%.0f%%", percentage))
                    .font(.subTitle1_semibold16)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Image(.gaugeBackground)
                .resizable()
                .frame(height: 28)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
    }
    
    var actionButtonView: some View {
        HStack(spacing: 12) {
            HomeButton(buttonTitle: "먹이주기", count: viewModel.homePetModel.feedCount)
                .onTapGesture {
                    Task {
                        await viewModel.feedPet()
                    }
                }
            HomeButton(buttonTitle: "놀아주기", count: viewModel.homePetModel.toyCount)
                .onTapGesture {
                    Task {
                        await viewModel.playWithPet()
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 66)
        .padding(.horizontal, 32)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(repository: HomeRepository()), coordinator: AppCoordinator())
}
