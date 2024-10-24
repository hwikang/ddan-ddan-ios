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
    
    /// 3일치 칼로리를 저장하는 배열
    var caloriesArray: [Double] = []
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
    
    /// 3일치의 칼로리를 배열에 저장하는 함수
    /// - Parameter completion: 데이터를 성공적으로 가져오면 `nil`, 오류가 발생하면 `Error`를 반환하는 클로저
    func readThreeDaysEnergyBurned(completion: @escaping (Error?) -> Void) {
        guard let healthStore = healthStore else {
            completion(NSError(domain: "HealthStoreError", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthStore is not available"]))
            return
        }
        
        let calendar = Calendar.current
        let endDate = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -3, to: endDate) else {
            completion(NSError(domain: "DateError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to calculate the start date"]))
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: energyBurnedType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] (query, samples, error) in
            guard let self = self, let samples = samples as? [HKQuantitySample] else {
                completion(error)
                return
            }
            caloriesArray = samples.map { $0.quantity.doubleValue(for: HKUnit.kilocalorie()) }
            completion(nil) // 에러가 없을 경우 nil을 반환
        }
        
        healthStore.execute(query)
    }
    
    /// 3일의 칼로리가 목표 칼로리를 넘었는지 확인하는 함수
    ///  - Parameter goalCalories: 사용자가 설정한 목표 칼로리 값
    func checkIfGoalMet(goalCalories: Double) -> Bool {
        for calorie in caloriesArray {
            if calorie < goalCalories {
                return false
            }
        }
        return true
    }
}
