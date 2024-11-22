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
                
                let goalKcal = userData.purposeCalorie
                let petType = petData.mainPet.type.rawValue
                let level = petData.mainPet.level
                
                let message = ["purposeKcal": goalKcal]
                let petTypeMessage = ["petType": petType]
                let levelMessage = ["level" : level]
                
                WatchConnectivityManager.shared.sendMessage(message: message)
                WatchConnectivityManager.shared.sendMessage(message: petTypeMessage)
                WatchConnectivityManager.shared.sendMessage(message: levelMessage)
                
                self.coordinator.setRoot(to: .home)
            }
        } else {
            DispatchQueue.main.async {
                self.coordinator.setRoot(to: .login)
            }
        }
    }

    @MainActor private func navigateToNextScreen() {
        if UserManager.shared.accessToken != nil {
            if UserManager.shared.isSignUpRequired() {
                coordinator.setRoot(to: .signUp)
            } else {
                coordinator.setRoot(to: .home)
            }
        } else {
            if UserDefaultValue.needToShowOnboarding {
                coordinator.setRoot(to: .onboarding)
            } else {
                coordinator.setRoot(to: .login)
            }
        }
    }
}
