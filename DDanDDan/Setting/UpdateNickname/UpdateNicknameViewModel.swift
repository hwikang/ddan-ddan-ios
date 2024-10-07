//
//  UpdateNicknameViewModel.swift
//  DDanDDan
//
//  Created by hwikang on 9/26/24.
//

import Foundation

final class UpdateNicknameViewModel: ObservableObject {
    @Published var nickname: String
    
    init(nickname: String) {
        self.nickname = nickname
    }
   
    public func update() async -> Bool {
        //TODO: update nickame API
        return true
    }
}
