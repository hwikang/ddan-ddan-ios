//
//  SignUpEggView.swift
//  DDanDDan
//
//  Created by paytalab on 8/17/24.
//

import SwiftUI

struct SignUpEggView: View {
    @State private var buttonDisabled: Bool = true
    @State private var signUpData: SignUpData
    @State private var selectedEgg: String? = nil
    @State private var nextButtonTapped: Bool = false

    public init(signUpData: SignUpData) {
        
        self.signUpData = signUpData
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        
                        Text("마음에 드는\n알을 선택해 주세요")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.top, 80)
                    
                        HStack(alignment: .center) {
                            Spacer()
                            eggGrid
                            Spacer()
                        }
                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    GreenButton(action: {
                        signUpData.selectedEgg = selectedEgg
                        nextButtonTapped = true
                    }, title: "다음", disabled: $buttonDisabled)
                    .onChange(of: selectedEgg) { newValue in
                        buttonDisabled = selectedEgg == nil
                    }
                    
                }
            }.navigationDestination(isPresented: $nextButtonTapped) {
                SignUpNicknameView(signUpData: signUpData)
            }
            
        }
    }
    
    var eggGrid: some View {
        VStack(spacing: 20) {
            HStack(spacing: 30) {
                Image("eggPink")
                    .onTapGesture {
                        selectedEgg = "Pink"
                    }
                Image("eggOrange")
                    .onTapGesture {
                        selectedEgg = "Orange"
                    }
            }
            HStack(spacing: 30) {
                Image("eggPurple")
                    .onTapGesture {
                        selectedEgg = "Purple"
                    }
                Image("eggPink")
                    .onTapGesture {
                        selectedEgg = "Pink"
                    }
            }
        }.padding(.top, 75)
    }
}

#Preview {
    SignUpEggView(signUpData: .init())
}
