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

    public init(signUpData: SignUpData) {
        
        self.signUpData = signUpData
    }
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    
                    Text("마음에 드는\n알을 선택해 주세요")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    
                        .padding(.top, 80)
                    
                    VStack(alignment: .center, spacing: 20) {
                        HStack(spacing: 30) {
                            Image("eggPink")
//                                .frame(width: 120,height: 120)
//                                .aspectRatio(contentMode: .fit)
                            Image("eggPink")
                                .frame(width: 120)
                        }
                        HStack(spacing: 30) {
                            Image("eggPink")
                                .frame(width: 120)
                            
                            Image("eggPink")
                                .frame(width: 120)
                        }
                    }.padding(.top, 75)
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                GreenButton(action: {
                    print("tap")
                }, title: "다음", disabled: $buttonDisabled)
                 
            }
        }
    }
}

#Preview {
    SignUpEggView(signUpData: .init())
}
