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
    
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
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
            showToastMessage(message: "하루 목표 칼로리가 변경되었어요")
            return true
        case .failure(let failure):
            //TODO: 에러처리
            return false
        }
    }
    
    public func increaseCalorie() {
        guard calorie < 1000 else {
            showToastMessage(message: "최대 1000칼로리까지 성장할 수 있어요")
            return
        }
        calorie += 100
    }
    
    public func decreaseCalorie() {
        guard calorie > 100 else {
            showToastMessage(message: "최소 100칼로리 이상 설정해주세요")
            return
        }
        calorie -= 100
    }
    
    private func showToastMessage(message: String) {
        toastMessage = message
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.hideToastMessage()
        }
    }
    
    private func hideToastMessage() {
        showToast = false
    }
}
