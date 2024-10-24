//
//  WatchViewModel.swift
//  DdanDdan_Watch Watch App
//
//  Created by 이지희 on 10/25/24.
//

import SwiftUI

enum PetType: String {
    case dog = "DOG"
    case cat = "CAT"
    case penguin = "PENGUIN"
    case hamster = "HAMSTER"
}

final class WatchViewModel: ObservableObject {
    var goalKcal: Int
    @Published var currentKcal: Int
    
    init(goalKcal: Int, currentKcal: Int = 200) {
        self.goalKcal = goalKcal
        self.currentKcal = currentKcal
        fetchActiveEnergyFromHealthKit()
    }
    
    func fetchActiveEnergyFromHealthKit() {
        HealthKitManager.shared.readActiveEnergyBurned { [weak self] kcal in
               DispatchQueue.main.async {
                   self?.currentKcal = Int(kcal)
               }
           }
       }
    
    // 목표 칼로리 도달 여부를 반환
    public var isGoalMet: Bool {
        return currentKcal >= goalKcal
    }
    
    // petType에 따른 UI 설정
    public func configureUI(petType: PetType) -> (ImageResource, Color) {
        switch petType {
        case .dog:
            return (.dog, .purpleGraphics)
        case .cat:
            return (.cat, .pinkGraphics)
        case .penguin:
            return (.peng, .blueGraphics)
        case .hamster:
            return (.ham, .greenGraphics)
        }
    }
    
    // 목표 대비 진행률 계산
    public func calculateProgress() -> Double {
        guard goalKcal > 0 else { return 0.0 }
        return min(Double(currentKcal) / Double(goalKcal), 1.0)
    }
}
