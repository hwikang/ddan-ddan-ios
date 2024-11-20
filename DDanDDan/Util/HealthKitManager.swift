//
//  HealthKitManager.swift
//  DDanDDan
//
//  Created by hwikang on 7/13/24.
//

import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    private var healthStore: HKHealthStore?
    private let energyBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    
    private init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func isAuthorized() -> Bool {
        guard let healthStore = healthStore else { return false }
        
        let stepType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let status = healthStore.authorizationStatus(for: stepType)
        
        return status == .sharingAuthorized
    }
    
    func checkAuthorization() -> HKAuthorizationStatus {
        guard let healthStore = healthStore else { return .notDetermined }
        
        let stepType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        return healthStore.authorizationStatus(for: stepType)
    }
    
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let healthStore = healthStore else {
            completion(false)
            return
        }
        
        let readTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
            completion(success)
        }
    }
    
    
    func readActiveEnergyBurned(completion: @escaping (Double) -> Void) {
        guard let healthStore = healthStore else {
            completion(0)
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: energyBurnedType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            var resultCount = 0.0
            
            guard let result = result else {
                print("Failed to fetch active energy burned = \(String(describing: error?.localizedDescription))")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.kilocalorie())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        
        healthStore.execute(query)
    }
    
    func checkIfGoalMet(goalCalories: Double, completion: @escaping (Double, Bool) -> Void) {
        guard let healthStore = healthStore else {
            completion(0, false)
            return
        }
        
        let calendar = Calendar.current
        let endDate = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -3, to: endDate) else {
            completion(0, false)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: energyBurnedType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] (query, samples, error) in
            guard let self = self, let samples = samples as? [HKQuantitySample] else {
                completion(0, false)
                return
            }
            
            // 칼로리 합산
            let totalCalories = samples.reduce(0) { $0 + $1.quantity.doubleValue(for: HKUnit.kilocalorie()) }
            
            // 목표 칼로리 초과 여부 판단
            let goalMet = totalCalories >= goalCalories
            
            // 합계와 목표 달성 여부를 반환
            completion(totalCalories, goalMet)
        }
        
        healthStore.execute(query)
    }

}
