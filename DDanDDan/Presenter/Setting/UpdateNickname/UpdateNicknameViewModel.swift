//
//  UpdateNicknameViewModel.swift
//  DDanDDan
//
//  Created by hwikang on 9/26/24.
//

import Foundation

public protocol UpdateNicknameViewModelProtocol: ObservableObject {
    var nickname: String { get set }
    func update() async -> Bool
}

final class UpdateNicknameViewModel: UpdateNicknameViewModelProtocol {
    @Published var nickname: String
    private let repository: SettingRepositoryProtocol
    init(nickname: String, repository: SettingRepositoryProtocol) {
        self.nickname = nickname
        self.repository = repository
    }
   
    public func update() async -> Bool {

        let result = await repository.update(name: nickname, purposeCalorie: UserDefaultValue.purposeKcal)
        switch result {
        case .success:
            return true
        case .failure(let failure):
            //TODO: 에러처리
            return false
        }
    }
}
