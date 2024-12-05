//
//  SplashViewModel.swift
//  DDanDDan
//
//  Created by 이지희 on 11/19/24.
//

import Foundation

final class SplashViewModel: ObservableObject {
    private let coordinator: AppCoordinator
    private let homeRepository: HomeRepository
    
    init(
        coordinator: AppCoordinator,
        homeRepository: HomeRepository
    ) {
        self.coordinator = coordinator
        self.homeRepository = homeRepository
    }
    
    
    func performInitialSetup() async {
        async let userInfo = homeRepository.getUserInfo()
        async let petInfo = homeRepository.getMainPetInfo()
        
        if case .success(let userData) = await userInfo,
           case .success(let petData) = await petInfo {
            DispatchQueue.main.async {
                self.coordinator.userInfo = userData
                self.coordinator.petInfo = petData
                
                UserDefaultValue.userId = userData.id
                UserDefaultValue.petType = petData.mainPet.type.rawValue
                UserDefaultValue.petId = petData.mainPet.id
                UserDefaultValue.purposeKcal = userData.purposeCalorie
                UserDefaultValue.level = petData.mainPet.level
                
                let info: [String: Any] = [
                    "purposeKcal": userData.purposeCalorie,
                    "petType": petData.mainPet.type.rawValue,
                    "level": petData.mainPet.level
                ]
                
                WatchConnectivityManager.shared.transferUserInfo(info: info)
                
                self.coordinator.setRoot(to: .home)
            }
        } else {
            DispatchQueue.main.async {
                self.coordinator.setRoot(to: .login)
            }
        }
    }
    
    @MainActor
    func navigateToNextScreen() {
        if !UserDefaultValue.isOnboardingComplete {
            coordinator.setRoot(to: .onboarding)
        } else if let accessToken = UserManager.shared.accessToken,
                  !accessToken.isEmpty {
            if UserManager.shared.isSignUpRequired() {
                coordinator.setRoot(to: .signUp)
            } else {
                Task {
                    await self.performInitialSetup()
                    coordinator.setRoot(to: .home)
                }
            }
        } else {
            coordinator.setRoot(to: .login)
        }
    }
    
}
