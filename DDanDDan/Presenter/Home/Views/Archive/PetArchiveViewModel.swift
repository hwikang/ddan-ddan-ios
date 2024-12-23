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
    
    @Published var petList: [Pet] = []
    @Published var selectedIndex: Int? = nil
    @Published var petId: String = ""
    @Published var isSelectedMainPet: Bool = false
    @Published var showToast = false
    @Published var gridItemCount: Int = 9
    
    
    init(repository: HomeRepositoryProtocol) {
        self.homeRepository = repository
    }
    
    func setSelectedPet() {
        for (index, pet) in petList.enumerated() {
            if pet.id == UserDefaultValue.petId {
                selectedIndex = index
                break
            }
        }
    }
    
    func toggleSelection(for index: Int) {
        if selectedIndex == index {
            selectedIndex = nil
        } else {
            selectedIndex = index
        }
        
        if let selectedPet = petList[safe: index] {
            petId = selectedPet.id
        }
    }
    
    func fetchPetArchive() async {
        let petArchiveModel = await homeRepository.getPetArchive()
        
        if case .success(let petArchive) = petArchiveModel {
            UserDefaultValue.userId = petArchive.ownerUserId
            DispatchQueue.main.async { [weak self] in
                self?.petList = petArchive.pets
                let petCount = petArchive.pets.count
                self?.gridItemCount = max(9, Int(ceil(Double(petCount) / 3.0)) * 3)
            }
        }
    }
    
    func selectMainPet(id: String) async {
        let result = await homeRepository.updateMainPet(petId: id)
        if case .success(let pet) = result {
            UserDefaultValue.petId = pet.mainPet.id
            UserDefaultValue.petType = pet.mainPet.type.rawValue
            DispatchQueue.main.async { [weak self] in
                self?.isSelectedMainPet = true
            }
        }
    }
    
    func showToastMessage() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.hideToastMessage()
        }
    }
    
    func hideToastMessage() {
        showToast = false
    }
}
