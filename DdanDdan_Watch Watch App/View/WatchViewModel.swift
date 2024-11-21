//
//  WatchViewModel.swift
//  DdanDdan_Watch Watch App
//
//  Created by 이지희 on 10/25/24.
//

import SwiftUI
import Combine

final class WatchViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    @Published var goalKcal: Int?
    @Published var currentKcal: Int
    @Published var currentKcalProgress: Double = 0.0
    @Published var viewConfig: (Image, Color)?
    @Published var showLoginAlert = false
    
    init(currentKcal: Int = 0) {
        self.currentKcal = currentKcal
        
        bindWatchApp()
        updateProgress()
    }
    
    /// HealthKit에서 활성 에너지(kcal) 받아와서 현재 칼로리, 도달률 계산
    public func fetchActiveEnergyFromHealthKit() {
        HealthKitManager.shared.readActiveEnergyBurned { [weak self] kcal in
            DispatchQueue.main.async {
                self?.currentKcal = Int(kcal)
                self?.updateProgress()
            }
        }
    }
    
    /// 도달률 업데이트
    public func updateProgress() {
        currentKcalProgress = calculateProgress()
    }
    
    /// 목표 칼로리 도달 여부를 반환
    public var isGoalMet: Bool {
        return currentKcal >= goalKcal ?? 0
    }
    
    /// petType에 따른 UI 설정
    public func configureUI(petType: PetType, level: Int) -> (Image, Color) {
        return (petType.image(for: level), petType.color)
    }
    
    /// 도달률 계산
    private func calculateProgress() -> Double {
        if let goalKcal {
            guard goalKcal > 0 else { return 0.0 }
            return min(Double(currentKcal) / Double(goalKcal), 1.0)
        }
        return 0
    }
    
    private func bindWatchApp() {
        WatchConnectivityManager.shared.$watchPet
            .receive(on: DispatchQueue.main)
            .sink { [weak self] watchPet in
                guard let self = self else { return }
                
                if let watchPet {
                    self.goalKcal = watchPet.goalKcal
                    self.viewConfig = configureUI(petType: watchPet.petType, level: watchPet.level)
                    self.updateProgress()
                } else {
                    self.showLoginAlert = true
                }
            }
            .store(in: &cancellables)
    }
}
