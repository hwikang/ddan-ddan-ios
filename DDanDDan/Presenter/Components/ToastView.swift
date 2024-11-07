//
//  ToastView.swift
//  DDanDDan
//
//  Created by 이지희 on 11/8/24.
//

import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.body1_regular16)
            .frame(width: 320, height: 60)
            .background(Color.textHeadlinePrimary)
            .foregroundColor(.backgroundBlack)
            .cornerRadius(8)
            .transition(.move(edge: .bottom).combined(with: .opacity)) // 애니메이션
    }
}
