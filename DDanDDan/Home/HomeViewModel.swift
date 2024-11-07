//
//  HomeViewModel.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI
import HealthKit

final class HomeViewModel: ObservableObject {
    @Published var homePetModel: HomeModel = .init(petType: .purpleDog, goalKcal: 0, feedCount: 0, toyCount: 0, level: 0)
    @Published var currentKcalModel: HomeKcalModel = .init(currentKcal: 0, level: 1)
    @Published var isGoalMet: Bool = false
    
    private let homeRepository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.homeRepository = repository
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
            
            await updateGoalStatus()
        }
    }
    
    /// 오늘의 칼로리 정보 초기화
    func initialCurrnetKcalModel() {
        HealthKitManager.shared.readActiveEnergyBurned { kcal in
            print("오늘의 칼로리: \(kcal)")
            self.currentKcalModel.currentKcal = Int(kcal)
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
    
    
    @MainActor
    private func updateGoalStatus() async {
        let goalCalories = Double(homePetModel.goalKcal)
        let goalMet = HealthKitManager.shared.checkIfGoalMet(goalCalories: goalCalories)
        self.isGoalMet = goalMet
    }
    
    /// 캐릭터에 맞는 배경 이미지
    func backgroundImage() -> Image {
        switch homePetModel.petType {
        case .pinkCat:
            return Image(.pinkBackground).resizable()
        case .greenHam:
            return Image(.greenBackground).resizable()
        case .purpleDog:
            return Image(.purpleBackground).resizable()
        case .bluePenguin:
            return Image(.blueBackground).resizable()
        }
    }
    
    /// 레벨에 맞는 캐릭터 이미지
    func characterImage() -> Image {
        switch (homePetModel.petType, currentKcalModel.level) {
        case (.pinkCat, 1):
            return Image(.pinkEgg).resizable()
        case (.pinkCat, 2):
            return Image(.pinkLv1).resizable()
        case (.pinkCat, 3):
            return Image(.pinkLv2).resizable()
        case (.pinkCat, 4):
            return Image(.pinkLv3).resizable()
        case (.pinkCat, 5):
            return Image(.pinkLv4).resizable()
        case (.greenHam, 1):
            return Image(.greenEgg).resizable()
        case (.greenHam, 2):
            return Image(.greenLv1).resizable()
        case (.greenHam, 3):
            return Image(.greenLv2).resizable()
        case (.greenHam, 4):
            return Image(.greenLv3).resizable()
        case (.greenHam, 5):
            return Image(.greenLv4).resizable()
        case (.bluePenguin, 1):
            return Image(.blueEgg).resizable()
        case (.bluePenguin, 2):
            return Image(.blueLv1).resizable()
        case (.bluePenguin, 3):
            return Image(.blueLv2).resizable()
        case (.bluePenguin, 4):
            return Image(.blueLv3).resizable()
        case (.bluePenguin, 5):
            return Image(.blueLv4).resizable()
        case (.purpleDog, 1):
            return Image(.purpleEgg).resizable()
        case (.purpleDog, 2):
            return Image(.purpleLv1).resizable()
        case (.purpleDog, 3):
            return Image(.purpleLv2).resizable()
        case (.purpleDog, 4):
            return Image(.purpleLv3).resizable()
        case (.purpleDog, 5):
            return Image(.purpleLv4).resizable()
        default:
            return Image(.pinkEgg).resizable() // Default character
        }
    }
}
