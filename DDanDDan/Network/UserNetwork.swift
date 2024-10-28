//
//  UserNetwork.swift
//  DDanDDan
//
//  Created by hwikang on 10/23/24.
//

import Foundation
import Alamofire
public struct UserNetwork {
    private let manager = NetworkManager()
    
    public func update(accessToken: String,
                       name: String?, purposeCalorie: Int?) async -> Result<UserData, NetworkError> {
        var parameter: Parameters = [:]
        if let name = name {
            parameter["name"] = name
        }
        if let purposeCalorie = purposeCalorie {
            parameter["purposeCalorie"] = purposeCalorie
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer " + accessToken]
        return await manager.request(url: "/v1/user/me", method: .put, headers: headers,
                                     parameters: parameter, encoding: JSONEncoding.default)
    }
    
    public func setMainPet(accessToken: String, petID: String) async -> Result<MainPet, NetworkError> {
        let parameter: Parameters = ["petId": petID]
        let headers: HTTPHeaders = ["Authorization": "Bearer " + accessToken]
        return await manager.request(url: "/v1/user/me/main-pet", method: .post, headers: headers,
                                     parameters: parameter, encoding: JSONEncoding.default)


    }
}
