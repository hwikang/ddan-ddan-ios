//
//  ReissueData.swift
//  DDanDDan
//
//  Created by 이지희 on 11/13/24.
//

import Foundation

public struct ReissueData: Decodable {
    let accessToken, refreshToken: String
    let user: UserData
    let isOnboardingComplete: Bool
}
