//
//  SignUpRepository.swift
//  DDanDDan
//
//  Created by hwikang on 10/25/24.
//

import Foundation

protocol SignUpRepositoryProtocol {
    func update(name: String?, purposeCalorie: Int?) async -> Result<UserData, NetworkError>
    func getKakaoToken() -> String?
    func login(token: String, tokenType: String) async -> Result<LoginData, NetworkError>
}

public struct SignUpRepository: SignUpRepositoryProtocol {
    private let network = UserNetwork()
    private let authNetwork = AuthNetwork()

    public func update(name: String?, purposeCalorie: Int?) async -> Result<UserData, NetworkError> {
        guard let accessToken = await UserManager.shared.accessToken else { return .failure(.requestFailed("Access Token Nil"))}
        let result = await network.update(accessToken: accessToken, name: name, purposeCalorie: purposeCalorie)
        if case .success(let userData) = result {
            await UserManager.shared.setUserData(userData)
        }
        return result
    }
    
    public func updateMainPet(petType: String) {
        //TODO: 펫추가 + 메인펫설정
    }
    @MainActor
    public func getKakaoToken() -> String? {
        return UserManager.shared.kakaoToken
    }
    
    public func login(token: String, tokenType: String) async -> Result<LoginData, NetworkError> {
        await authNetwork.login(token: token, tokenType: tokenType)
    }
}
