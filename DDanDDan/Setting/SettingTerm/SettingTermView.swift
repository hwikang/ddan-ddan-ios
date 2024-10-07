//
//  SettingTermView.swift
//  DDanDDan
//
//  Created by hwikang on 10/7/24.
//

import SwiftUI

enum SettingTerm: CaseIterable {
    case service
    case privacy
    
    var description: String {
        switch self {
        case .privacy: "개인정보 처리방침"
        case .service: "서비스 이용약관"
        }
    }
    
    var urlString: String {
        switch self {
        case .privacy: "https://www.naver.com"
        case .service: "https://www.naver.com"
        }
    }
    
    
}
struct SettingTermView: View {
    var body: some View {
        ZStack {
            Color.backgroundBlack.edgesIgnoringSafeArea(.all)
            List(SettingTerm.allCases, id: \.self) { item in
                NavigationLink(destination: WebView(url: item.urlString)) {
                    Text(item.description)

                }
                .foregroundStyle(.white)
                .listRowBackground(Color.backgroundBlack)
                
            }
            .listRowSeparator(.hidden)
            .listStyle(.plain)
            
            
        }
        .navigationTitle("약관 및 개인정보 처리 동의")
    }
}

#Preview {
    SettingTermView()
}
