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
    @Published var currentKcalModel: HomeKcalModel = .init(currentKcal: 0, level: 1)
    @Published var isGoalMet: Bool = false
    @Published var archeivePercent: Double = 0
    
    @Published var earnFood: Int = 0
    @Published var isPresentEarnFood: Bool = false
    
    private let homeRepository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.homeRepository = repository
        Task {
            await fetchHomeInfo()
        }
        initialCurrnetKcalModel()
    }
    
    @MainActor
    func fetchHomeInfo() async {
        
        let userInfo = await homeRepository.getUserInfo()
        let mainPetInfo = await homeRepository.getMainPetInfo()
        
        if case .success(let userData) = userInfo,
           case .success(let petData) = mainPetInfo {
            // HomeModel을 업데이트합니다.
            self.homePetModel = HomeModel(
                petType: petData.mainPet.type,
                goalKcal: userData.purposeCalorie,
                feedCount: userData.foodQuantity,
                toyCount: userData.toyQuantity,
                level: petData.mainPet.level
            )
            self.archeivePercent = petData.mainPet.expPercent
            self.currentKcalModel.level = petData.mainPet.level
            UserDefaultValue.petType = petData.mainPet.type.rawValue
            UserDefaultValue.petId = petData.mainPet.id
            
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
        var earnedFeed = 0
        
        // HealthKit에서 소모 칼로리 읽기
        HealthKitManager.shared.readActiveEnergyBurned { kcal in
            let increaseKcal = kcal - UserDefaultValue.currentKcal
            
            if increaseKcal >= 100 {
                earnedFeed = Int(increaseKcal / 100)
                if earnedFeed > 0 {
                    self.earnFood = earnedFeed
                    self.isPresentEarnFood = true
                    
                    UserDefaultValue.currentKcal = kcal
                }
            }
        }
    }
    
    func patchCurrentKcal() async {
        let result = await homeRepository.updateDailyKcal(calorie: currentKcalModel.currentKcal)
        
        if case .success(let dailyInfo) = result {
            DispatchQueue.main.async { [weak self] in
                self?.homePetModel.feedCount = dailyInfo.user.foodQuantity
            }
        }
    }
    
    
    /// 먹이주기
    func feedPet() async {
        let result = await homeRepository.feedPet(petId: UserDefaultValue.petId)
        
        if case .success(let userData) = result {
            homePetModel.feedCount = userData.user.foodQuantity
        }
    }
    
    /// 놀아주기
    func playWithPet() async {
        let result = await homeRepository.playPet(petId: UserDefaultValue.petId)
        
        if case .success(let userData) = result {
            homePetModel.toyCount = userData.user.toyQuantity
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
    
    @MainActor
    private func updateGoalStatus() async {
        let goalCalories = Double(homePetModel.goalKcal)
        let goalMet = HealthKitManager.shared.checkIfGoalMet(goalCalories: goalCalories)
        self.isGoalMet = goalMet
    }
    
}
