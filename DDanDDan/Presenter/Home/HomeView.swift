//
//  HomeView.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI
import HealthKit

import Lottie

enum HomePath: Hashable {
    case setting
    case petArchive
    case successThreeDay(totalKcal: Int)
    case newPet
    case upgradePet(level: Int, petType: PetType)
}

struct HomeView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject var viewModel: HomeViewModel
    
    private let isSEDevice = UIScreen.isSESizeDevice
    
    var body: some View {
        
        ZStack {
            Color(.backgroundBlack)
                .ignoresSafeArea()
            VStack {
                navigationBar
                    .padding(.top, 20)
                    .padding(.bottom, isSEDevice ? 8 : 16)
                kcalView
                    .padding(.bottom, isSEDevice ? 24 : 14)
                ZStack {
                    if isSEDevice {
                        viewModel.homePetModel.petType.seBackgroundImage
                            .scaledToFit()
                            .padding(.horizontal, 53)
                    } else {
                        viewModel.homePetModel.petType.backgroundImage
                            .scaledToFit()
                    }
                    VStack {
                        Image(viewModel.bubbleImage)
                            .opacity(viewModel.showBubble ? 1 : 0)
                            .animation(.easeInOut(duration: 0.3).delay(0.1), value: viewModel.showBubble)
                            .transition(.opacity)
                            .frame(minWidth: 75, maxWidth: 167, minHeight: 56)
                            .offset(y: 10)
                        petImage
                            .onTapGesture {
                                viewModel.showRandomBubble(type: .normal)
                            }
                    }
                    .offset(y: isSEDevice ? 20 : 65)
                    
                }
                .padding(.bottom, isSEDevice ? 15 : 32)
                levelView
                    .padding(.bottom, 20)
                actionButtonView
            }
            .frame(maxHeight: .infinity, alignment: .top)
            TransparentOverlayView(isPresented: $viewModel.showToast) {
                VStack {
                    ToastView(message: viewModel.toastMessage)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .opacity)) // 사라질 때는 페이드 아웃만
                .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3), value: viewModel.showToast)
                .position(x: UIScreen.main.bounds.width / 2 + 10, y: UIScreen.main.bounds.height - 250)
            }
            TransparentOverlayView(isPresented: $viewModel.isPresentEarnFood) {
                ImageDialogView(
                    show: $viewModel.isPresentEarnFood,
                    image: .eatGraphic,
                    title: "먹이를 얻었어요!",
                    description: "사과 \(viewModel.earnFood)개",
                    buttonTitle: "획득하기"
                ) {
                    viewModel.showRandomBubble(type: .success)
                }
            }
            .onChange(of: viewModel.isLevelUp) { newLevel in
                if newLevel {
                    coordinator.push( to: .upgradePet(
                        level: viewModel.homePetModel.level,
                        petType: viewModel.homePetModel.petType
                    )
                    )
                }
            }
            .onChange(of: viewModel.isMaxLevel) { newValue in
                if newValue {
                    coordinator.push( to: .newPet)
                }
            }
            .onChange(of: viewModel.isGoalMet) { newValue in
                if newValue {
                    coordinator.push( to: .successThreeDay(totalKcal: viewModel.threeDaysTotalKcal))
                }
            }
            .onReceive(coordinator.$shouldUpdateHomeView) { shouldUpdate in
                if shouldUpdate {
                    Task {
                        await viewModel.fetchHomeInfo()
                        
                        coordinator.shouldUpdateHomeView = false
                    }
                }
            }
            
        }
        .navigationDestination(for: HomePath.self) { path in
            switch path {
            case .setting:
                SettingView(coordinator: coordinator)
            case .petArchive:
                PetArchiveView(coordinator: coordinator, viewModel: PetArchiveViewModel(repository: HomeRepository()))
            case .successThreeDay(let totalKcal):
                ThreeDaySuccessView(coordinator: coordinator, totalKcal: totalKcal)
            case .newPet:
                NewPetView(coordinator: coordinator, viewModel: NewPetViewModel(homeRepository: HomeRepository()))
            case .upgradePet(let level, let petType):
                LevelUpView(coordinator: coordinator, level: level, petType: petType)
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
            Button(action: {
                coordinator.push(to: .setting)
            }) {
                Image(.iconSetting)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 32)
    }
    
    var kcalView: some View {
        HStack(spacing: 4) {
            Text("\(viewModel.currentKcal)")
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
    
    var petImage: some View {
        Group {
            if (viewModel.homePetModel.petType != .bluePenguin) {
                if viewModel.isPlayingSpecialAnimation {
                    LottieView(animation: .named(viewModel.currentLottieAnimation))
                        .playing(loopMode: .playOnce)
                        .frame(width: 105, height: 105)
                } else {
                    LottieView(animation: .named(viewModel.homePetModel.petType.lottieString(level: viewModel.homePetModel.level)))
                        .playing(loopMode: .loop)
                        .frame(width: 105, height: 105)
                }
            } else {
                viewModel.homePetModel.petType.image(for: viewModel.homePetModel.level)
                    .scaledToFit()
                    .frame(width: 105, height: 105)
            }
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
                Text(String(format: "%.0f%%", viewModel.homePetModel.exp))
                    .font(.subTitle1_semibold14)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            ZStack(alignment: .leading) {
                Image(.gaugeBackground)
                    .resizable()
                    .frame(height: 28)
                
                // expCount 계산
                let expCount = min(Int(viewModel.homePetModel.exp) / 3, 28)
                
                // Rectangle 생성
                HStack(spacing: 4) {  // HStack을 사용하여 왼쪽 정렬 및 패딩 처리
                    ForEach(0..<29, id: \.self) { index in
                        if index < expCount {
                            Rectangle()
                                .fill(viewModel.homePetModel.petType.color)
                                .frame(width: 8, height: 12)
                        } else {
                            Rectangle()
                                .fill(Color.clear)  // 비어 있는 부분은 투명하게
                                .frame(width: 8, height: 12)
                        }
                    }
                }
                .padding(.leading, 12) // 첫 번째 여백은 8, 그 외의 여백은 HStack 내에서 처리됨
            }
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
    HomeView(coordinator: .init(), viewModel: HomeViewModel(repository: HomeRepository()))
}
