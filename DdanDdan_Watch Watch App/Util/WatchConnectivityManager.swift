//
//  WatchConnectivityManager.swift
//  DdanDdan_Watch Watch App
//
//  Created by 이지희 on 10/25/24.
//

import WatchConnectivity
import SwiftUI

/// 워치 앱에서의 WatchConnectivity 설정
class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()
    
    @Published var purposeKcal: Double = 0.0
    @Published var petType: String = ""
    @Published var level: Int = 0
    
    override private init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    // MARK: - 필수 구현 메서드 및 Delegate 메서드
    
    /// 세션 활성화 완료 시 호출
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activation completed with state: \(activationState)")
    }
    
    /// 워치로 iPhone으로부터 메시지를 받았을 때 처리하는 메서드
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        print("Received user info: \(userInfo)")
        
        DispatchQueue.main.async {
            if let purposeKcal = userInfo["purposeKcal"] as? Double {
                self.purposeKcal = purposeKcal
            }
            if let petType = userInfo["petType"] as? String {
                self.petType = petType
            }
            if let level = userInfo["level"] as? Int {
                self.level = level
            }
        }
    }
}
