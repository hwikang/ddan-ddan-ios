//
//  ImageDialogView.swift
//  DDanDDan
//
//  Created by 이지희 on 11/8/24.
//

import SwiftUI

struct ImageDialogView: View {
    @Binding public var show: Bool
    public let image: ImageResource, title: String, description: String, rightButtonTitle: String ,leftButtonTitle: String
    var rightButtonHandler: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Image(image)
                Text(title)
                    .font(.headline)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.white)
                    .padding()
                
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(red: 166/255, green: 166/255, blue: 166/255))
                Button(rightButtonTitle) {
                    withAnimation {
                        show.toggle()
                        rightButtonHandler?()
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.buttonGreen)
                .foregroundColor(.black)
                .cornerRadius(4)
                .padding(.vertical, 20)
            }
            .frame(width: 300, height: 200)
            .background(Color(red: 33/255, green: 33/255, blue: 33/255))
            .cornerRadius(8)
            .shadow(radius: 20)
        }
        .background(Color.clear.opacity(0))
    }
}
