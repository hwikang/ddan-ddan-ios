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
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
            }
        }
        .navigationTitle("설정")
        
    }
}

#Preview {
    SettingView()
}
