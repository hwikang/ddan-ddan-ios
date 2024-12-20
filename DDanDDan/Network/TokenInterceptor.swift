//
//  TokenInterceptor.swift
//  DDanDDan
//
//  Created by 이지희 on 11/13/24.
//

import Foundation

import Alamofire

public final class TokenInterceptor: Interceptor {
    
    public override func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let network = AuthNetwork()
        let refreshToken = UserDefaultValue.refreshToken
        
        Task {
            let result = await network.tokenReissue(refreshToken: refreshToken ?? "")
            if case .success(let reissueData) = result {
                UserDefaultValue.acessToken = reissueData.accessToken
                UserDefaultValue.refreshToken = reissueData.refreshToken
                
                completion(.retry)
            } else if case .failure(let failure) = result {
                print("🔻 Retry Error 발생")
                print("Error: \(failure.localizedDescription)")
                
                Task {
                    await UserManager.shared.logout()
                }
                
                completion(.doNotRetry)
            }
        }
    }
}
