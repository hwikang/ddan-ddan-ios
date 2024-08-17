//
//  SignUpTermView.swift
//  DDanDDan
//
//  Created by paytalab on 7/29/24.
//

import SwiftUI
import Combine

struct SignUpTermView: View {
    @State private var serviceTermAgree: Bool = false
    @State private var privacyTermAgree: Bool = false
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
                    
                    Text("딴딴에 오신 것을 환영합니다")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    
                        .padding(.top, 80)
                    Text("서비스 시작 및 가입을 위해 먼저\n가입 및 정보 제공에 동의해 주세요.")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                    
                        .padding(.top, 8)
                    Button {
                        let isAllAgree = serviceTermAgree && privacyTermAgree
                        buttonDisabled = isAllAgree
                        serviceTermAgree = !isAllAgree
                        privacyTermAgree = !isAllAgree
                    } label: {
                        let image = serviceTermAgree && privacyTermAgree ? "checkboxCircleSelected" : "checkboxCircle"
                        Label("전체동의", image: image)
                            .foregroundColor(.gray)
                            .font(.system(size: 16, weight: .bold))
                    }
                    TermButton(title: "서비스 이용약관", imageName: serviceTermAgree ? "checkboxSelected" :"checkbox", pointTitle: "(필수)") {
                        serviceTermAgree.toggle()
                    } viewTerm: {
                        print("term")
                    }
                    .padding(.top, 12)
                    TermButton(title: "개인정보 처리방침", imageName:privacyTermAgree ? "checkboxSelected" :"checkbox", pointTitle: "(필수)") {
                        privacyTermAgree.toggle()
                    }viewTerm: {
                        print("term")
                    }
                    .padding(.top, 12)
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                GreenButton(action: {
                    print("tap")
                }, title: "시작하기", disabled: $buttonDisabled)
                 
            }
        }
    }
}

struct TermButton: View {
    private let title: String, imageName: String, pointTitle: String
    private let action: () -> Void
    private let viewTerm: () -> Void
    init(title: String, imageName: String, pointTitle: String, 
         action: @escaping () -> Void,
         viewTerm: @escaping () -> Void) {
        self.title = title
        self.imageName = imageName
        self.pointTitle = pointTitle
        self.action = action
        self.viewTerm = viewTerm
    }
    
    var body: some View {
        HStack {
            Button(action: action) {
                HStack {
                    Image(imageName)
                    Text("\(pointTitle) ")
                        .foregroundColor(Color(red: 19/255, green: 230/255, blue: 169/255))
                    + Text(title)
                        .foregroundColor(Color(red: 201/255, green: 201/255, blue: 201/255))
                        .font(.system(size: 16))
                    
                }
            }
            Spacer()
            Button(action: viewTerm) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
       
        
    }
}

#Preview {
    SignUpTermView(signUpData: .init())
}

