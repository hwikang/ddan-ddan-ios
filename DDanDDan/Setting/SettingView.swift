//
//  SettingView.swift
//  DDanDDan
//
//  Created by paytalab on 9/10/24.
//

import SwiftUI

enum SettingPath: Hashable {
    
}

struct SettingView: View {
    @State public var path: [SettingPath] = []
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.backgroundBlack
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
    }
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
               
                Color.black.edgesIgnoringSafeArea(.bottom)
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
        }
       
        
    }
}

#Preview {
    SettingView()
}
