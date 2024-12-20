//
//  String+.swift
//  DDanDDan
//
//  Created by 이지희 on 11/21/24.
//

import Foundation

extension String {
    /// "yyyy-MM-dd" 형식의 문자열을 `Date`로 변환
    func toDate(format: String = "yyyy-MM-dd", locale: Locale = Locale(identifier: "en_US_POSIX")) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.date(from: self)
    }
}
