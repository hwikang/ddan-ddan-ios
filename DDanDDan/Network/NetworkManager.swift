//
//  NetworkManager.swift
//  DDanDDan
//
//  Created by hwikang on 10/23/24.
//

import Foundation
import Alamofire

public struct NetworkManager {
    private let baseURL = "https://ddan-ddan.com"
    private let session: Session
    
    public init(interceptor: Interceptor? = nil) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = Session(configuration: config, interceptor: interceptor)
    }

    public func request<T: Decodable>(url: String, method: HTTPMethod,
                                       headers: HTTPHeaders? = nil,
                                       parameters: Parameters? = nil,
                                       encoding: ParameterEncoding = URLEncoding.default) async -> Result<T, NetworkError> {
        guard let url = URL(string: baseURL + url) else {
            return .failure(NetworkError.urlError)
        }
        
        // 네트워크 로그 출력
        print("\n📡 Request:")
        print("🔹 URL: \(url)")
        print("🔹 Method: \(method.rawValue)")
        if let headers = headers {
            print("🔹 Headers: \(headers)")
        }
        if let parameters = parameters {
            print("🔹 Parameters: \(parameters)")
        }

        let result = await session.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate().serializingData().response
        
        // 응답 로그 출력
        print("\n📥 Response:")
        if let error = result.error {
            print("🔹 Error: \(error.localizedDescription)")
            return .failure(NetworkError.requestFailed(error.errorDescription ?? ""))
        }

        guard let data = result.data else {
            print("🔹 Error: Data is nil")
            print("====================================")
            return .failure(NetworkError.dataNil)
        }
        
        guard let response = result.response else {
            print("🔹 Error: Invalid response")
            print("====================================")
            return .failure(NetworkError.invalidResponse)
        }
        
        print("🔹 Status Code: \(response.statusCode)")
        
        if 200..<400 ~= response.statusCode {
            do {
                let networkResponse = try JSONDecoder().decode(T.self, from: data)
                print("🔹 Success: \(networkResponse)")
                print("====================================")
                return .success(networkResponse)
            } catch {
                print("🔹 Decoding Error: \(error.localizedDescription)")
                print("====================================")
                return .failure(NetworkError.failToDecode(error.localizedDescription))
            }
        } else {
            print("🔹 Server Error: \(response.statusCode)")
            print("====================================")
            return .failure(NetworkError.serverError(response.statusCode))
        }
    }
}
