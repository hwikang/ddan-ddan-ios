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
        
        let result = session.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
        
        // 응답 로그 출력
        print("\n📥 Response:")
        if let error = result.error {
            print("🔹 Error: \(error.localizedDescription)")
            return .failure(NetworkError.requestFailed(error.errorDescription ?? ""))
        }
        
        guard let response = result.response else {
            print("🔹 Error: Invalid response")
            print("====================================")
            return .failure(NetworkError.invalidResponse)
        }
        
        print("🔹 Status Code: \(response.statusCode)")
        
        if 200..<400 ~= response.statusCode {
            if let data = result.data, !data.isEmpty {
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    print("🔹 Success: \(decodedResponse)")
                    return .success(decodedResponse)
                } catch {
                    print("🔹 Decoding Error: \(error.localizedDescription)")
                    return .failure(NetworkError.failToDecode(error.localizedDescription))
                }
            } else if T.self is EmptyResponse.Type, let emptyResponse = T.self as? EmptyResponse.Type {
                print("🔹 Empty Response")
                return .success(emptyResponse.emptyValue() as! T)
            } else {
                print("🔹 Error: Data is nil or empty, and T is not EmptyResponse")
                return .failure(NetworkError.dataNil)
            }
        } else {
            print("🔹 Server Error: \(response.statusCode)")
            print("====================================")
            return .failure(NetworkError.serverError(response.statusCode))
        }
    }
}
