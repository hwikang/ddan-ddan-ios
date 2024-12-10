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
        
        do {
            let userData = try await unwrapResult(userInfo)
            let petData = try await unwrapResult(petInfo)
            
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
        } catch {
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
                }
            }
        } else {
            coordinator.setRoot(to: .login)
        }
    }
    
    /// 통신 결과를 안전하게 처리하는 헬퍼 메서드
    private func unwrapResult<T>(_ result: Result<T, NetworkError>) async throws -> T {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
