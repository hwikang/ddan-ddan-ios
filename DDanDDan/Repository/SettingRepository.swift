//
//  SettingRepository.swift
//  DDanDDan
//
//  Created by hwikang on 10/28/24.
//

import Foundation

protocol SettingRepositoryProtocol {
    func update(name: String?, purposeCalorie: Int?) async -> Result<UserData, NetworkError>
    func deleteUser(reason: String) async -> Result<EmptyEntity, NetworkError>
    func getUserData() async -> UserData?
}

public struct SettingRepository: SettingRepositoryProtocol {
    private let network = UserNetwork()
    
    public func update(name: String?, purposeCalorie: Int?) async -> Result<UserData, NetworkError> { 
        guard let accessToken = await UserManager.shared.accessToken else { return .failure(.requestFailed("Access Token Nil"))}
        let result = await network.update(accessToken: accessToken, name: name, purposeCalorie: purposeCalorie)
        if case .success(let userData) = result {
            await UserManager.shared.setUserData(userData)
        }
        return result
    }
    public func deleteUser(reason: String) async -> Result<EmptyEntity, NetworkError> {
        guard let accessToken = await UserManager.shared.accessToken else { return .failure(.requestFailed("Access Token Nil"))}
        return await network.deleteUser(accessToken: accessToken, reason: reason)
    }
    public func getUserData() async -> UserData? {
        await UserManager.shared.getUserData()
    }
}
