//
//  PetArchiveModel.swift
//  DDanDDan
//
//  Created by 이지희 on 11/7/24.
//

import Foundation

public struct PetArchiveModel: Decodable {
    let ownerUserId: String
    let pets: [Pet]
}
