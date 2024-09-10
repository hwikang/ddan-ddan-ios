//
//  SignUpEggView.swift
//  DDanDDan
//
//  Created by paytalab on 8/17/24.
//

import SwiftUI

public struct SignUpEggView: View {
    @State private var buttonDisabled: Bool = true
    @State public var signUpData: SignUpData
    @State private var selectedEgg: String? = nil
    @Binding public var path: [SignUpPath]
    
    public var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                
                Text("마음에 드는\n알을 선택해 주세요")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.top, 80)
                    .padding(.horizontal, 20)
                HStack(alignment: .center) {
                    Spacer()
                    eggGrid
                    Spacer()
                }
                
                Spacer()
                
                GreenButton(action: {
                    signUpData.selectedEgg = selectedEgg
                    path.append(.nickname)
                }, title: "다음", disabled: $buttonDisabled)
                .onChange(of: selectedEgg) { newValue in
                    buttonDisabled = selectedEgg == nil
                }
                
            }
        }
    }
    
    var eggGrid: some View {
        VStack(spacing: 20) {
            HStack(spacing: 30) {
                EggItem(selectedEgg: $selectedEgg, imageName: "eggPink", title: "Pink")
                EggItem(selectedEgg: $selectedEgg, imageName: "eggOrange", title: "Orange")
                
            }
            HStack(spacing: 30) {
                EggItem(selectedEgg: $selectedEgg, imageName: "eggPurple", title: "Purple")
                EggItem(selectedEgg: $selectedEgg, imageName: "eggPink", title: "Pink")
                
            }
        }.padding(.top, 75)
    }
}

struct EggItem: View {
    @Binding var selectedEgg: String?
    public let imageName: String, title: String
    
    var body: some View {
        Image(imageName)
            .onTapGesture {
                selectedEgg = title
            }
            .overlay(RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color(red: 19/255, green: 230/255, blue: 149/255),
                              lineWidth: selectedEgg == title ? 3 : 0))
    }
}

#Preview {
    SignUpEggView(signUpData: .init(), path: .constant([]))
}
