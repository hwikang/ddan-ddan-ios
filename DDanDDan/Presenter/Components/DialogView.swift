//
//  DialogView.swift
//  DDanDDan
//
//  Created by hwikang on 7/21/24.
//

import SwiftUI

struct DialogView: View {
    @Binding public var show: Bool
    public let title: String, description: String, rightButtonTitle: String ,leftButtonTitle: String
    var rightButtonHandler: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(title)
                    .font(.headline)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.white)
                    .padding()
                
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(red: 166/255, green: 166/255, blue: 166/255))
                
                
                HStack(alignment: .center) {
                    Button(leftButtonTitle) {
                        withAnimation {
                            show.toggle()
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    Button(rightButtonTitle) {
                        withAnimation {
                            show.toggle()
                            rightButtonHandler?()
                        }
                    }
                    
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 19/255, green: 230/255, blue: 149/255))
                    .foregroundColor(.black)
                    .cornerRadius(4)
                }
                .padding(20)
            }
            .frame(width: 300, height: 200)
            .background(Color(red: 33/255, green: 33/255, blue: 33/255))
            .cornerRadius(8)
            .shadow(radius: 20)
        }
    }
}

//#Preview {
//    DialogView(show: $true, title: "title", description: "description", rightButtonTitle: "OK", leftButtonTitle: "Cancel")
//}
