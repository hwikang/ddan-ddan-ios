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
    @Published var isLevelUp: Bool = false
    
    @Published var isHealthKitAuthorized: Bool = true // 초기값은 true로 설정
    @Published var currentKcal = 0
    @Published var threeDaysTotalKcal: Int = 0
    
    @Published var earnFood: Int = 0
    @Published var isPresentEarnFood: Bool = false
    
    @Published var bubbleText = ""
    @Published var bubbleImage: ImageResource = .minBubble
    @Published var showBubble: Bool = false
    
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    
    private var petId = ""
    
    private let homeRepository: HomeRepositoryProtocol
    
    init(
        repository: HomeRepositoryProtocol,
        userInfo: HomeUserInfo? = nil,
        petInfo: MainPet? = nil
    ) {
        self.homeRepository = repository
        
        checkHealthKitAuthorization()
        
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
        
        initialCurrnetKcalModel()
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
            
            if UserDefaultValue.level != petInfo.mainPet.level {
                isLevelUp = true
                UserDefaultValue.level = petInfo.mainPet.level
            }
            
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
    
    func initialCurrnetKcalModel() {
        let lastDate = UserDefaultValue.date
        let currentDate = Date()
        let calendar = Calendar.current
        
        if UserDefaultValue.currentKcal < 0 { UserDefaultValue.currentKcal = 0 }
        
        // 날짜가 다르면 currentKcal을 0으로 초기화하고 저장된 날짜 업데이트
        if !calendar.isDate(lastDate, inSameDayAs: currentDate) {
            UserDefaultValue.currentKcal = 0
            UserDefaultValue.date = currentDate
        }
       
        // HealthKit에서 오늘의 소모 칼로리 읽기
        HealthKitManager.shared.readActiveEnergyBurned { kcal in
            DispatchQueue.main.async { [weak self] in
                self?.currentKcal = Int(kcal)
                self?.earnFeed()
                
                if Int(kcal) > UserDefaultValue.purposeKcal {
                    self?.showRandomBubble(type: .success)
                } else {
                    self?.showRandomBubble(type: .failure)
                }
                
                HealthKitManager.shared.checkIfGoalMet(goalCalories: Double(self?.homePetModel.goalKcal ?? 0)) { [weak self] totalKcal, goalMet in
                    DispatchQueue.main.async {
                        self?.isGoalMet = goalMet
                        self?.threeDaysTotalKcal = Int(totalKcal)
                    }
                }
            }
        }
        
    }

    func earnFeed() {
        HealthKitManager.shared.readActiveEnergyBurned { kcal in
            let lastCheckedKcal = UserDefaultValue.currentKcal
            let increaseKcal = kcal - lastCheckedKcal
            
            guard increaseKcal >= 100 else {
                print("100 칼로리가 넘지 않았습니다. 증가량: \(increaseKcal)")
                return
            }
            
            // 지급할 먹이 계산
            let earnedFeed = Int(increaseKcal / 100)
            
            if earnedFeed > 0 {
                self.earnFood = earnedFeed
                self.isPresentEarnFood = true
            }
        }
    }
    
    func patchCurrentKcal(earnedFeed: Int) async {
        let result = await homeRepository.updateDailyKcal(calorie: currentKcal)
        
        if case .success(let dailyInfo) = result {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.homePetModel.feedCount = dailyInfo.user.foodQuantity
                UserDefaultValue.currentKcal = Double(dailyInfo.dailyInfo.calorie)
                UserDefaultValue.date = dailyInfo.dailyInfo.date.toDate() ?? Date()
                print("업데이트된 칼로리: \(UserDefaultValue.currentKcal)")
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
            }
        }
    }
    
    // 말풍선 이미지 선택 로직
    func bubbleImage(for characterCount: Int) -> ImageResource {
        switch characterCount {
        case 1...3:
            return .minBubble
        case 3...5:
            return .fourBubble
        case 5...6:
            return .fiveBubble
        default:
            return .maxBubble
        }
    }
    
    @MainActor
    func showRandomBubble(type: bubbleTextType) {
        // 이전에 보였던 말풍선이 사라지도록 설정
        showBubble = false
        let randomMessage = type.getRandomText().randomElement() ?? "안녕"
        self.bubbleText = randomMessage
        self.bubbleImage = self.bubbleImage(for: randomMessage.count)
        
        // 새로운 말풍선이 보이도록 설정
        withAnimation {
            self.showBubble = true
        }
        
        // 3초 후에 자동으로 사라지게 설정
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.showBubble = false
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
        let healthKitManager = HealthKitManager.shared
        
        // 현재 권한 상태를 확인
        let currentStatus = healthKitManager.checkAuthorization()
        
        if currentStatus == .notDetermined {
            healthKitManager.requestAuthorization { [weak self] authorized in
                DispatchQueue.main.async {
                    if authorized {
                        self?.isHealthKitAuthorized = healthKitManager.checkAuthorization() == .sharingAuthorized
                        self?.initialCurrnetKcalModel()
                        HealthKitManager.shared.checkIfGoalMet(goalCalories: Double(self?.homePetModel.goalKcal ?? 0)) { [weak self] totalKcal, goalMet in
                            self?.isGoalMet = goalMet
                            self?.threeDaysTotalKcal = Int(totalKcal)
                        }
                    } else {
                        self?.isHealthKitAuthorized = false
                    }
                }
            }
        }
    }
}
