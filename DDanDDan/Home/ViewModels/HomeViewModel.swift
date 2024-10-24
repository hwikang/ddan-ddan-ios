//
//  HomeViewModel.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI
import HealthKit

final class HomeViewModel: ObservableObject {
    /// 기본 정보를 담은 모델
    /// 오늘의 칼로리 정보
    var homePetModel: HomeModel
    var currentKcalModel: HomeKcalModel = .init(currentKcal: 0, level: 0)
    
    init(model: HomeModel) {
        /// 서버 통신을 통해 받아오는 펫 정보
        self.homePetModel = model
        /// HealthKit 통신으로 받아오는 칼로리 정보
        initialCurrnetKcalModel()
    }
    
    func initialCurrnetKcalModel() {
        HealthKitManager.shared.readActiveEnergyBurned { kcal in
            print("today Calories: \(kcal)")
            self.currentKcalModel.currentKcal = Int(kcal)
            
        }
    }
    
    /// 3일 치 칼로리 가져오기
    /// 보상 창으로 이동
    func getThreeDaysKcal() -> Bool {
        var isGoalMet: Bool = false
        HealthKitManager.shared.readThreeDaysEnergyBurned { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching calories: \(error.localizedDescription)")
            } else {
                print("Three Days Calories: \(HealthKitManager.shared.caloriesArray)")
                isGoalMet = HealthKitManager.shared.checkIfGoalMet(goalCalories: Double(self.homePetModel.goalKcal))
            }
        }
        return isGoalMet
    }
    
    /// 캐릭터에 맞는 배경
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
