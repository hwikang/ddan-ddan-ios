//
//  SignUpCalorieViewModel.swift
//  DDanDDan
//
//  Created by paytalab on 8/24/24.
//

import Foundation

struct SignUpCalorieViewModel {
    
    public func signUp(signupData: SignUpData) async -> Bool {
        print(signupData)
        //TODO: signup 요청
        return true
    }
    
    public func login() -> Bool {
        //TODO: login 요청 + 토큰 저장
        return true
    }
}
