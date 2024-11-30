//
//  DeleteUserViewModel.swift
//  DDanDDan
//
//  Created by hwikang on 10/7/24.
//

import Foundation

final class DeleteUserViewModel: ObservableObject {
    @Published var name: String = ""
    private let repository: SettingRepositoryProtocol

    init(repository: SettingRepositoryProtocol) {
        self.repository = repository
        getUserName()
    }
    public func deleteUser(reasons: Set<String>) async -> Bool {
        let result = await repository.deleteUser(reason: reasons.reduce("") { $0 + ", " + $1 })
        switch result {
        case .success:
            return true
        case .failure(let error):
            //TODO: 에러처리
            return false
        }
        
    }
    
    public func getUserName() {
        Task {
            if let name = await UserManager.shared.getUserData()?.name {
                self.name = name
            }
        }
        
    }
}
