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

        let energyBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
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
}
