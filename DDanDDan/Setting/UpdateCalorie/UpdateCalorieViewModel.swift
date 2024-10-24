//
//  UpdateCalorieViewModel.swift
//  DDanDDan
//
//  Created by hwikang on 9/26/24.
//

import Foundation

final class UpdateCalorieViewModel: ObservableObject {
  
    @Published var calorie: Int
    
    init(calorie: Int) {
        self.calorie = calorie
    }
    
    public func update() async -> Bool {
        //TODO: update nickame API
        return true
    }
    
    public func increaseCalorie() {
        guard calorie < 1000 else { return }
        calorie += 100
    }
    
    public func decreaseCalorie() {
        guard calorie > 100 else { return }
        calorie -= 100
    }
}
