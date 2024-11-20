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
                        Image(.arrow)
                    }
                    .frame(width: 24, height: 24)
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                if backButtonAction != nil {
                    Spacer()
                        .frame(width: 24)
                }
            }
        }
        .frame(height: 40)
    }
}
