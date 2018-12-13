//
//  HealthKitHelper.swift
//  Golf Score Card
//
//  Created by Scott Bennett on 12/12/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    let healthStore = HKHealthStore()
    
    func authorizeHealthKit() -> Bool {
        var isEnabled = true
        // Is HealthKit data available on this device?
        if HKHealthStore.isHealthDataAvailable() {
            print("HealthKit data is available")
            
            let stepsCount = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
                        
            healthStore.requestAuthorization(toShare: nil, read: (stepsCount as! Set<HKObjectType>)) { (success, error) -> Void in
                isEnabled = success
                }
        } else {
            isEnabled = false
        }
        return isEnabled
    }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                print("Failed to fetch steps rate")
                completion(resultCount)
                return
            }
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }

}
