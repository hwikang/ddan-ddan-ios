//
//  DeleteUserViewModel.swift
//  DDanDDan
//
//  Created by hwikang on 10/7/24.
//

import Foundation

final class DeleteUserViewModel: ObservableObject {
    init() {
        getUserName()
    }
    @Published var name: String = ""
    
    public func deleteUser(reason: Set<String>) async -> Bool {
        //TODO: delete User API
        return true
    }
    
    public func getUserName() {
        Task {
            if let name = await UserManager.shared.getUserData()?.name {
                self.name = name
            }
        }
        
    }
}
