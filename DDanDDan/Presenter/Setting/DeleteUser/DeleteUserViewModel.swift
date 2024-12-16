//
//  DeleteUserViewModel.swift
//  DDanDDan
//
//  Created by hwikang on 10/7/24.
//

import Foundation

import KakaoSDKUser

final class DeleteUserViewModel: ObservableObject {
    @Published var name: String = ""
    private let repository: SettingRepositoryProtocol
    
    init(repository: SettingRepositoryProtocol) {
        self.repository = repository
        name = UserDefaultValue.nickName
    }
    public func deleteUser(reasons: Set<String>) async -> Bool {
        let result = await repository.deleteUser(reason: reasons.reduce("") {
            $0.isEmpty ? $1 : $0 + ", " + $1 }
        )
        switch result {
        case .success:
            UserApi.shared.unlink {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("unlink() success.")
                }
            }
            return true
        case .failure(let error):
            //TODO: 에러처리
            return false
        }
        
    }
}
