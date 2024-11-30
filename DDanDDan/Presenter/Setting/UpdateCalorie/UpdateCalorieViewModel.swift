//
//  UpdateCalorieViewModel.swift
//  DDanDDan
//
//  Created by hwikang on 9/26/24.
//

import Foundation
public protocol UpdateCalorieViewModelProtocol: ObservableObject {
    var calorie: Int { get set }
    func update() async -> Bool
}

final class UpdateCalorieViewModel: UpdateCalorieViewModelProtocol {
  
    @Published var calorie: Int = 100
    private let repository: SettingRepositoryProtocol

    init(repository: SettingRepositoryProtocol) {
        self.repository = repository
        getUserCalorie()
    }
    
    private func getUserCalorie() {
        Task {
            if let userData = await repository.getUserData() {
                calorie = userData.purposeCalorie
            }
        }
    }
    
    public func update() async -> Bool {
        var userName = ""
        
        if let user = await getUserName() {
            userName = user
        } else {
            userName = UserDefaultValue.userId
        }
        
        let result = await repository.update(name: userName, purposeCalorie: calorie)
        switch result {
        case .success:
            UserDefaultValue.purposeKcal = calorie
            return true
        case .failure(let failure):
            //TODO: 에러처리
            return false
        }
    }
    
    private func getUserName() async -> String? {
        let user = await UserManager.shared.getUserData()
        return user?.name
    }
    
    public func increaseCalorie() {
        guard calorie < 1000 else { return }
        calorie += 100
    }
    
    public func decreaseCalorie() {
        guard calorie > 100 else { return }
        calorie -= 100
    }
}
