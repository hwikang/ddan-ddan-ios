//
//  HomeViewModel.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI
import HealthKit
final class HomeViewModel: ObservableObject {
    @Published var homePetModel: HomeModel
    @Published var currentKcalModel: HomeKcalModel = .init(currentKcal: 0, level: 1)
    @Published var isGoalMet: Bool = false // 목표 도달 여부를 나타내는 속성
    
    init(model: HomeModel) {
        self.homePetModel = model
        initialCurrnetKcalModel()
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
                let goalMet = HealthKitManager.shared.checkIfGoalMet(goalCalories: Double(self.homePetModel.goalKcal))
                self.isGoalMet = goalMet
                completion(goalMet)
            }
        }
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
