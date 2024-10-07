//
//  DeleteUserViewModel.swift
//  DDanDDan
//
//  Created by hwikang on 10/7/24.
//

import Foundation

final class DeleteUserViewModel: ObservableObject {
    public let reasons: [String] = [
        "쓰지 않는 앱이에요", "오류가 생겨서 쓸 수 없어요"
    ]
    
    public func deleteUser(reason: String) async -> Bool {
        //TODO: delete User API
        return true
    }
    
   
}
