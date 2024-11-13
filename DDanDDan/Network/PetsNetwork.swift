//
//  PetsNetwork.swift
//  DDanDDan
//
//  Created by hwikang on 10/28/24.
//


import Foundation
import Alamofire

public struct PetsNetwork {
    private let manager = NetworkManager(interceptor: TokenInterceptor())
    
    // MARK: - GET
    
    public func fetchSpecificPet(accessToken: String, petId: String) async -> Result<Pet, NetworkError> {
        let headers: HTTPHeaders = ["Authorization": "Bearer " + accessToken]
        
        return await manager.request(
            url: PathString.Pet.fetchPet + petId,
            method: .get,
            headers: headers
        )
    }
    
    public func fetchPetArchieve(accessToken: String) async -> Result<PetArchiveModel, NetworkError> {
        let headers: HTTPHeaders = ["Authorization": "Bearer " + accessToken]
        
        return await manager.request(
            url: PathString.Pet.userPets,
            method: .get,
            headers: headers
        )
    }
    
    // MARK: - POST
    
    public func addPet(accessToken: String, petType: PetType) async -> Result<Pet, NetworkError> {
        let parameter: Parameters = [
            "petType": petType.rawValue
        ]
        let headers: HTTPHeaders = ["Authorization": "Bearer " + accessToken]
        
        return await manager.request(
            url: PathString.Pet.userPets,
            method: .post,
            headers: headers,
            parameters: parameter,
            encoding: JSONEncoding.default
        )
    }
    
    public func addRandomPet(accessToken: String) async -> Result<Pet, NetworkError> {
        let headers: HTTPHeaders = ["Authorization": "Bearer " + accessToken]
        
        return await manager.request(
            url: PathString.Pet.randomPet,
            method: .post,
            headers: headers
        )
    }
    
    public func postPetFeed(accessToken: String, petId: String) async -> Result<DailyUserData, NetworkError> {
        let parameter: Parameters = [
            "petId": petId
        ]
        let headers: HTTPHeaders = ["Authorization": "Bearer " + accessToken]
        
        return await manager.request(
            url: PathString.Pet.userPets + petId + "/food",
            method: .post, headers: headers,
            parameters: parameter,
            encoding: JSONEncoding.default
        )
    }
    
    public func postPetPlay(accessToken: String, petId: String) async -> Result<DailyUserData, NetworkError> {
        let parameter: Parameters = [
            "petId": petId
        ]
        let headers: HTTPHeaders = ["Authorization": "Bearer " + accessToken]
        
        return await manager.request(
            url: PathString.Pet.userPets + petId + "/play",
            method: .post, headers: headers,
            parameters: parameter,
            encoding: JSONEncoding.default
        )
    }
}

