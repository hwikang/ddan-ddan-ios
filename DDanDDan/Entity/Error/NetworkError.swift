//
//  NetworkError.swift
//  DDanDDan
//
//  Created by hwikang on 10/23/24.
//

import Foundation

public enum NetworkError: Error {
    case urlError
    case invalidResponse
    case failToDecode(String)
    case dataNil
    case serverError(Int, String)
    case requestFailed(String)
    case encodingError
    public var description: String {
        switch self {
        case .urlError: return "URL 이 올바르지 않습니다."
        case .dataNil: return "데이터가 없습니다."
        case .failToDecode(let message): return "디코딩 에러 \(message)"
        case .invalidResponse: return "유효하지 않은 응답 값입니다."
        case .serverError(let code, let message): return "서버 에러: \(code), \(message)"
        case .requestFailed(let message): return "서버 요청 실패 \(message)"
        case .encodingError: return "인코딩 실패"
        }
    }
}


struct ServerErrorResponse: Decodable {
    let code: String
    let message: String
    let data: String?
}
