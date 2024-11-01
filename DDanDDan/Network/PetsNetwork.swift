//
//  PetsNetwork.swift
//  DDanDDan
//
//  Created by hwikang on 10/28/24.
//


import Foundation
import Alamofire

public struct PetsNetwork {
    private let manager = NetworkManager()
    
    public func addPet(accessToken: String, petType: PetType) async -> Result<Pet, NetworkError> {
        let parameter: Parameters = [
            "petType": petType.rawValue
        ]
        let headers: HTTPHeaders = ["Authorization": "Bearer " + accessToken]

        return await manager.request(url: "/v1/pets/me", method: .post, headers: headers, parameters: parameter, encoding: JSONEncoding.default)
    }
}
