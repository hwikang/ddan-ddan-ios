//
//  Array+.swift
//  DDanDDan
//
//  Created by 이지희 on 11/21/24.
//

import Foundation

extension Array {
    // 배열의 안전한 인덱스 접근을 위한 확장
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
