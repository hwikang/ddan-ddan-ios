//
//  SignUpViewModel.swift
//  DDanDDan
//
//  Created by hwikang on 10/23/24.
//

import Foundation
import KakaoSDKUser
import KakaoSDKCommon

public class LoginViewModel: ObservableObject {
    private let repository: LoginRepositoryProtocol
    let appCoordinator: AppCoordinator
    
    init(repository: LoginRepositoryProtocol, appCoordinator: AppCoordinator) {
        self.repository = repository
        self.appCoordinator = appCoordinator
    }
    
    func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk(serviceTerms: []) { [weak self] token, error in
                if let error = error {
                    print(error)
                    return
                }
                self?.login(token: token?.accessToken)
                self?.appCoordinator.setRoot(to: .home)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount(serviceTerms: []) { [weak self] token, error in
                if let error = error {
                    print(error)
                    return
                }
                self?.login(token: token?.accessToken)
                self?.appCoordinator.setRoot(to: .home)
            }
        }
    }
    
    private func login(token: String?) {
        guard let token = token else { return }
       
        Task {
            await saveKakaoToken(token: token)
            let result = await repository.login(token: token, tokenType:"KAKAO")
            switch result {
            case .success(let loginData):
                await UserManager.shared.login(loginData: loginData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @MainActor
    private func saveKakaoToken(token: String) {
        UserManager.shared.kakaoToken = token
    }
}
