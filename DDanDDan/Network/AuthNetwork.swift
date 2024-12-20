//
//  AuthNetwork.swift
//  DDanDDan
//
//  Created by hwikang on 10/23/24.
//

import Foundation
import Alamofire

public struct AuthNetwork {
    private let manager = NetworkManager()
    
    public func login(token: String, tokenType: String) async -> Result<LoginData, NetworkError> {
        let parameter: Parameters = [
            "token": token,
            "tokenType": tokenType
        ]
        
        return await manager.request(url: "/v1/auth/login", method: .post, parameters: parameter, encoding: JSONEncoding.default)
    }
    
    public func tokenReissue(refreshToken: String) async -> Result<ReissueData, NetworkError> {
        let parameter: Parameters = [
            "refreshToken": refreshToken
        ]
        
        return await manager.request(url: PathString.Auth.reissue, method: .post, parameters: parameter, encoding: JSONEncoding.default)
    }
}
