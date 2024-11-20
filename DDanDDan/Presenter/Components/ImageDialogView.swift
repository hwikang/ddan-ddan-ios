//
//  ImageDialogView.swift
//  DDanDDan
//
//  Created by 이지희 on 11/8/24.
//

import SwiftUI

struct ImageDialogView: View {
    @Binding public var show: Bool
    public let image: ImageResource, title: String, description: String, buttonTitle: String
    var buttonHandler: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Image(image)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .padding(.bottom, 24)
                    .padding(.top, 20)
                Text(title)
                    .font(.headline)
                    .font(.heading7_medium16)
                    .foregroundStyle(Color.white)
                Text(description)
                    .font(.body2_regular14)
                    .foregroundStyle(Color(red: 166/255, green: 166/255, blue: 166/255))
                Button(buttonTitle) {
                    withAnimation {
                        show.toggle()
                        buttonHandler?()
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.buttonGreen)
                .foregroundColor(.black)
                .cornerRadius(4)
                .padding(20)
                
            }
            .frame(width: 308, height: 278)
            .background(Color(red: 33/255, green: 33/255, blue: 33/255))
            .cornerRadius(8)
            .shadow(radius: 20)
        }
        .background(Color.clear.opacity(0))
    }
}
