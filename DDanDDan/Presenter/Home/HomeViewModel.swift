//
//  HomeViewModel.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI
import HealthKit

final class HomeViewModel: ObservableObject {
    @Published var homePetModel: HomeModel = .init(petType: .bluePenguin, level: 0, exp: 0, goalKcal: 0, feedCount: 0, toyCount: 0)
    
    @Published var isGoalMet: Bool = false
    @Published var isMaxLevel: Bool = false
    @Published var isLevelUp: Bool = false
    
    @Published var isHealthKitAuthorized: Bool = true // 초기값은 true로 설정
    @Published var currentKcal = 0
    @Published var threeDaysTotalKcal: Int = 0
    
    @Published var earnFood: Int = 0
    @Published var isPresentEarnFood: Bool = false
    
    @Published var bubbleImage: ImageResource = .default1
    @Published var showBubble: Bool = false
    
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    
    private var petId = ""
    private var previousKcal: Int = 0
    
    private let healthKitManager = HealthKitManager.shared
    private let homeRepository: HomeRepositoryProtocol
    
    init(
        repository: HomeRepositoryProtocol,
        userInfo: HomeUserInfo? = nil,
        petInfo: MainPet? = nil
    ) {
        self.homeRepository = repository
        
        // 권한 체크
        checkHealthKitAuthorization()
        
        // 스플래쉬에서 받아오는 정보들
        if let userInfo = userInfo, let petInfo = petInfo {
            self.homePetModel = HomeModel(
                petType: petInfo.mainPet.type,
                level: petInfo.mainPet.level,
                exp: Double(petInfo.mainPet.expPercent),
                goalKcal: userInfo.purposeCalorie,
                feedCount: userInfo.foodQuantity,
                toyCount: userInfo.toyQuantity
            )
            
            self.petId = petInfo.mainPet.id
        }
        
        observeHealthKitData()
    }
    
    private func observeHealthKitData() {
        healthKitManager.observeActiveEnergyBurned { [weak self] newKcal in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.currentKcal = Int(newKcal)
                self.handleKcalUpdate(newKcal: Int(newKcal))
            }
        }
    }
    
    @MainActor
    func fetchHomeInfo() async {
        
        let userData = await homeRepository.getUserInfo()
        let mainPetData = await homeRepository.getMainPetInfo()
        
        if case .success(let userInfo) = userData,
           case .success(let petInfo) = mainPetData {
            UserDefaultValue.userId = userInfo.id
            UserDefaultValue.petType = petInfo.mainPet.type.rawValue
            UserDefaultValue.petId = petInfo.mainPet.id
            UserDefaultValue.purposeKcal = userInfo.purposeCalorie
            
            self.petId = petInfo.mainPet.id
            self.homePetModel = HomeModel(
                petType: petInfo.mainPet.type,
                level: petInfo.mainPet.level,
                exp: Double(petInfo.mainPet.expPercent),
                goalKcal: userInfo.purposeCalorie,
                feedCount: userInfo.foodQuantity,
                toyCount: userInfo.toyQuantity
            )
            
            let goalKcal = userInfo.purposeCalorie
            let petType = petInfo.mainPet.type.rawValue
            let level = petInfo.mainPet.level
            
            let message = ["purposeKcal": goalKcal]
            let petTypeMessage = ["petType": petType]
            let levelMessage = ["level" : level]
            
            WatchConnectivityManager.shared.sendMessage(message: message)
            WatchConnectivityManager.shared.sendMessage(message: petTypeMessage)
            WatchConnectivityManager.shared.sendMessage(message: levelMessage)
        }
    }
    
    func saveCurrentKcal(currentKcal: Int) async {
        let result = await homeRepository.updateDailyKcal(calorie: currentKcal)
        
        if case .success(let dailyInfo) = result {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                /// 현재 먹이 개수와 다르면 먹이 얻기
                if self.homePetModel.feedCount != dailyInfo.user.foodQuantity {
                    self.earnFood = dailyInfo.user.foodQuantity - self.homePetModel.feedCount
                    self.isPresentEarnFood = true
                }
                
                if self.homePetModel.toyCount != dailyInfo.user.toyQuantity {
                    HealthKitManager.shared.readThreeDaysTotalKcal { [weak self] totalKcal in
                        guard let self else { return }
                        self.threeDaysTotalKcal = Int(totalKcal)
                        self.isGoalMet = true
                    }
                }
                
                self.homePetModel.feedCount = dailyInfo.user.foodQuantity
                self.homePetModel.toyCount = dailyInfo.user.toyQuantity
                
                UserDefaultValue.currentKcal = Double(dailyInfo.dailyInfo.calorie)
                UserDefaultValue.date = dailyInfo.dailyInfo.date.toDate() ?? Date()
            }
        }
    }
    
    
    /// 먹이주기
    func feedPet() async {
        guard homePetModel.feedCount > 0 else {
            DispatchQueue.main.async { [weak self] in
                self?.toastMessage = "먹이가 부족해요!"
                self?.showToastMessage()
            }
            return
        }
        
        let result = await homeRepository.feedPet(petId: petId)
        if case .success(let petData) = result {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.showRandomBubble(type: .eat)
                self.homePetModel.feedCount = petData.user.foodQuantity
                self.homePetModel.exp = petData.pet.expPercent
                
                // 레벨 변화 확인
                if self.homePetModel.level != petData.pet.level {
                    self.homePetModel.level = petData.pet.level
                    self.isLevelUp = true
                }
                
                if petData.pet.level == 5 && petData.pet.expPercent == 100 && !isMaxLevel {
                    self.isMaxLevel = true
                }
            }
        }
    }
    
    /// 놀아주기
    func playWithPet() async {
        guard homePetModel.toyCount > 0 else {
            DispatchQueue.main.async { [weak self] in
                self?.toastMessage = "장난감이 부족해요!"
                self?.showToastMessage()
            }
            return
        }
        
        let result = await homeRepository.playPet(petId: petId)
        if case .success(let petData) = result {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.showRandomBubble(type: .play)
                self.homePetModel.toyCount = petData.user.toyQuantity
                self.homePetModel.exp = petData.pet.expPercent
                
                // 레벨 변화 확인
                if self.homePetModel.level != petData.pet.level {
                    self.homePetModel.level = petData.pet.level
                    self.isLevelUp = true
                }
                
                if petData.pet.level == 5 && petData.pet.expPercent == 100 && !isMaxLevel {
                    self.isMaxLevel = true
                }
            }
        }
    }
    
    
    @MainActor
    func showRandomBubble(type: bubbleTextType) {
        // 이전 말풍선이 없을 때만 보이도록
        if showBubble == false {
            self.bubbleImage = type.getRandomText().randomElement() ?? .default1
            
            withAnimation {
                self.showBubble = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.showBubble = false
                }
            }
        }
    }
    
    private func handleKcalUpdate(newKcal: Int) {
        let kcalDifference = (newKcal % 100) - (previousKcal % 100)
        
        if kcalDifference >= 1 {
            Task {
                await saveCurrentKcal(currentKcal: newKcal)
            }
            previousKcal = newKcal
        }
        
        // 목표 칼로리 초과 여부 확인 및 말풍선 처리
        if newKcal >= homePetModel.goalKcal {
            DispatchQueue.main.async { [weak self] in
                self?.showRandomBubble(type: .success)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.showRandomBubble(type: .failure)
            }
        }
    }
    
    private func showToastMessage() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.hideToastMessage()
        }
    }
    
    private func hideToastMessage() {
        showToast = false
    }
    
    private func checkHealthKitAuthorization() {
        if !healthKitManager.isAuthorized() {
            healthKitManager.requestAuthorization { _ in }
        }
    }
}
