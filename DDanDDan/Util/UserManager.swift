//
//  UserManager.swift
//  DDanDDan
//
//  Created by hwikang on 10/14/24.
//

import Foundation

actor UserManager: ObservableObject {
    static let shared = UserManager()
    
    //TODO: 목데이터 제거
    private var userData: UserData? = .init(id: "", name: "강휘", purposeCalorie: 100, foodQuantity: 2, toyQuantity: 2)
    @MainActor @Published var accessToken: String? = UserDefaultValue.acessToken
    private init() {
    }
    
    func setUserData(_ data: UserData) {
        self.userData = data
    }

    func getUserData() -> UserData? {
        return self.userData
    }
    
    func logout() async {
        userData = nil
        await MainActor.run {
            accessToken = nil
        }
       
    }
}
