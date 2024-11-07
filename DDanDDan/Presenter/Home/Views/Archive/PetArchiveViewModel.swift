//
//  PetArchieveViewModel.swift
//  DDanDDan
//
//  Created by 이지희 on 11/8/24.
//

import SwiftUI
import HealthKit

final class PetArchiveViewModel: ObservableObject {
    private let homeRepository: HomeRepositoryProtocol
    
    @Published var PetList: [Pet] = []
    
    init(repository: HomeRepositoryProtocol) {
        self.homeRepository = repository
        Task {
            await fetchPetArchive()
        }
    }
    
    @MainActor
    func fetchPetArchive() async {
        let petArchiveModel = await homeRepository.getPetArchive()
        
        if case .success(let petArchive) = petArchiveModel {
            UserDefaultValue.userId = petArchive.ownerUserId
            PetList = petArchive.pets
        }
    }
    
    /// 레벨에 맞는 캐릭터 이미지
    func characterImage(petType: PetType, level: Int) -> Image {
        switch (petType, level) {
        case (.pinkCat, 1):
            return Image(.pinkEgg).resizable()
        case (.pinkCat, 2):
            return Image(.pinkLv1).resizable()
        case (.pinkCat, 3):
            return Image(.pinkLv2).resizable()
        case (.pinkCat, 4):
            return Image(.pinkLv3).resizable()
        case (.pinkCat, 5):
            return Image(.pinkLv4).resizable()
        case (.greenHam, 1):
            return Image(.greenEgg).resizable()
        case (.greenHam, 2):
            return Image(.greenLv1).resizable()
        case (.greenHam, 3):
            return Image(.greenLv2).resizable()
        case (.greenHam, 4):
            return Image(.greenLv3).resizable()
        case (.greenHam, 5):
            return Image(.greenLv4).resizable()
        case (.bluePenguin, 1):
            return Image(.blueEgg).resizable()
        case (.bluePenguin, 2):
            return Image(.blueLv1).resizable()
        case (.bluePenguin, 3):
            return Image(.blueLv2).resizable()
        case (.bluePenguin, 4):
            return Image(.blueLv3).resizable()
        case (.bluePenguin, 5):
            return Image(.blueLv4).resizable()
        case (.purpleDog, 1):
            return Image(.purpleEgg).resizable()
        case (.purpleDog, 2):
            return Image(.purpleLv1).resizable()
        case (.purpleDog, 3):
            return Image(.purpleLv2).resizable()
        case (.purpleDog, 4):
            return Image(.purpleLv3).resizable()
        case (.purpleDog, 5):
            return Image(.purpleLv4).resizable()
        default:
            return Image(.questionMark).resizable() // Default character
        }
    }
}
