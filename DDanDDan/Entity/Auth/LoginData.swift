//
//  LoginData.swift
//  DDanDDan
//
//  Created by hwikang on 10/23/24.
//

import Foundation

public struct LoginData: Decodable {
    public let accessToken: String
    public let refreshToken: String
    public let user: UserData
    public let isOnboardingComplete: Bool
}
