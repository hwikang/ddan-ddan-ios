//
//  HomeViewModel.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI
import HealthKit

final class HomeViewModel: ObservableObject {
    @Published var homePetModel: HomeModel = .init(
        petType: .init(rawValue: UserDefaultValue.petType) ?? .purpleDog,
        goalKcal: UserDefaultValue.purposeKcal,
        feedCount: 0,
        toyCount: 0,
        level: 0
    )
    @Published var currentKcalModel: HomeKcalModel = .init(currentKcal: 0, level: 1, exp: 0)
    @Published var isGoalMet: Bool = false
    @Published var isHealthKitAuthorized: Bool = true // 초기값은 true로 설정

    
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
                goalKcal: userInfo.purposeCalorie,
                feedCount: userInfo.foodQuantity,
                toyCount: userInfo.toyQuantity,
                level: petInfo.mainPet.level
            )
            self.currentKcalModel = HomeKcalModel(
                currentKcal: Int(UserDefaultValue.currentKcal),
                level: petInfo.mainPet.level,
                exp: petInfo.mainPet.expPercent
            )
            self.petId = petInfo.mainPet.id
        } else {
            Task {
                await fetchHomeInfo()
            }
        }
        
        initialCurrnetKcalModel()
    }
    
    @MainActor
    func fetchHomeInfo() async {
        
        let userInfo = await homeRepository.getUserInfo()
        let mainPetInfo = await homeRepository.getMainPetInfo()
        
        if case .success(let userData) = userInfo,
           case .success(let petData) = mainPetInfo {
            UserDefaultValue.userId = userData.id
            UserDefaultValue.petType = petData.mainPet.type.rawValue
            UserDefaultValue.petId = petData.mainPet.id
            UserDefaultValue.purposeKcal = userData.purposeCalorie
            
            self.petId = petData.mainPet.id
            self.homePetModel = HomeModel(
                petType: petData.mainPet.type,
                goalKcal: userData.purposeCalorie,
                feedCount: userData.foodQuantity,
                toyCount: userData.toyQuantity,
                level: petData.mainPet.level
            )
            
            self.currentKcalModel.level = petData.mainPet.level
            self.currentKcalModel.exp = petData.mainPet.expPercent
            
            let watchData = WatchPetModel.init(
                petType: petData.mainPet.type,
                goalKcal: userData.purposeCalorie,
                level: petData.mainPet.level
            )
            
            WatchConnectivityManager.shared.sendMessage(message: ["watchPet" : watchData])
            
            await updateGoalStatus()
        }
    }
    
    func initialCurrnetKcalModel() {
        let lastDate = UserDefaultValue.date
        let currentDate = Date()
        let calendar = Calendar.current
        
        // 날짜가 다르면 currentKcal을 0으로 초기화하고 저장된 날짜 업데이트
        if !calendar.isDate(lastDate, inSameDayAs: currentDate) {
            UserDefaultValue.currentKcal = 0
            UserDefaultValue.date = currentDate
        }
        
        // HealthKit에서 오늘의 소모 칼로리 읽기
        HealthKitManager.shared.readActiveEnergyBurned { kcal in
            DispatchQueue.main.async { [weak self] in
                self?.currentKcalModel.currentKcal = Int(kcal)
                self?.earnFeed()
            }
        }
    }
    
    /// 3일 치 칼로리 가져오기 (Completion Handler 사용)
    func getThreeDaysKcal(completion: @escaping (Bool) -> Void) {
        HealthKitManager.shared.readThreeDaysEnergyBurned { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("칼로리 데이터를 가져오는 중 오류 발생: \(error.localizedDescription)")
                completion(false)
            } else {
                print("3일 치 칼로리: \(HealthKitManager.shared.caloriesArray)")
                let goalMet = HealthKitManager.shared.checkIfGoalMet(goalCalories: Double(homePetModel.goalKcal))
                self.isGoalMet = goalMet
                completion(goalMet)
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
        let result = await homeRepository.updateDailyKcal(calorie: currentKcalModel.currentKcal)
        
        if case .success(let dailyInfo) = result {
            DispatchQueue.main.async { [weak self] in
                self?.homePetModel.feedCount = dailyInfo.user.foodQuantity
                
                // 지급한 칼로리만큼 업데이트
                UserDefaultValue.currentKcal += Double(earnedFeed * 100)
                print("업데이트된 칼로리: \(UserDefaultValue.currentKcal)")
            }
        }
    }
    
    
    /// 먹이주기
    @MainActor
    func feedPet() async {
        guard homePetModel.feedCount > 0 else {
            DispatchQueue.main.async { [weak self] in
                self?.toastMessage = "먹이가 부족해요!"
                self?.showToastMessage()
            }
            return
        }
        
        let result = await homeRepository.feedPet(petId: petId)
        if case .success(_) = result {
            showRandomBubble(type: .eat)
            homePetModel.feedCount = homePetModel.feedCount - 1
            Task {
                await fetchHomeInfo()
            }
        }
    }
    
    /// 놀아주기
    @MainActor
    func playWithPet() async {
        guard homePetModel.toyCount > 0 else {
            DispatchQueue.main.async { [weak self] in
                self?.toastMessage = "장남감이 부족해요!"
                self?.showToastMessage()
            }
            return
        }
        
        let result = await homeRepository.playPet(petId: petId)

        if case .success(_) = result {
            showRandomBubble(type: .play)
            homePetModel.toyCount = homePetModel.toyCount - 1
        }
    }
    
    /// 캐릭터에 맞는 배경 이미지
    func backgroundImage() -> Image {
        return homePetModel.petType.backgroundImage
    }
    
    /// 레벨에 맞는 캐릭터 이미지
    func characterImage() -> Image {
        return homePetModel.petType.image(for: homePetModel.level)
    }
    
    // 말풍선 이미지 선택 로직
    func bubbleImage(for characterCount: Int) -> ImageResource {
        print(characterCount)
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
                    } else {
                        self?.isHealthKitAuthorized = false
                    }
                }
            }
        }
    }

}
