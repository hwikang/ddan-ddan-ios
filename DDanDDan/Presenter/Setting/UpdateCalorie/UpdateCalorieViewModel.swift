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
        calorie =  UserDefaultValue.purposeKcal
    }
    
    public func update() async -> Bool {
        
        let result = await repository.update(name: UserDefaultValue.nickName,
                                             purposeCalorie: calorie)
        switch result {
        case .success:
            return true
        case .failure(let failure):
            //TODO: 에러처리
            return false
        }
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
