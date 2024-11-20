//
//  NavigationBarView.swift
//  DDanDDan
//
//  Created by 이지희 on 11/21/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    var title: String
    var backButtonAction: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Color.backgroundBlack
                .ignoresSafeArea(edges: .top)
            
            HStack {
                if let backButtonAction = backButtonAction {
                    Button(action: backButtonAction) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    .padding(.leading)
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                if backButtonAction != nil {
                    Spacer()
                        .frame(width: 44) // 버튼과 균형 맞춤
                }
            }
        }
        .frame(height: 56) // 네비게이션 바 높이
    }
}
