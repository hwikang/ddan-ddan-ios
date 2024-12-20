//
//  CheckButton.swift
//  DDanDDan
//
//  Created by 이지희 on 11/21/24.
//

import SwiftUI

struct CheckButton: View {
    var isChecked: Bool
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(isChecked ? .checkboxCircleSelected : .checkboxCircle)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.body1_regular16)
                    .foregroundColor(.textBodyTeritary) // 텍스트 색상
                    .padding(.leading, 8) // 이미지와 간격
            }
        }
    }
}
