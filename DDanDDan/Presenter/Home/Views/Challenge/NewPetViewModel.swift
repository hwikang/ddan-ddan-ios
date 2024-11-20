//
//  NewPetViewModel.swift
//  DDanDDan
//
//  Created by 이지희 on 11/20/24.
//

import Foundation

final class NewPetViewModel: ObservableObject {
    private let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    func createRandomPet() async {
        let result = await homeRepository.addNewRandomPet()
    }
}
