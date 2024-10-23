//
//  PetArchiveView.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI

struct PetArchiveView: View {
    @Environment(\.dismiss) private var dismiss
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            Color(.backgroundBlack)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(.arrow)
                    }
                    .frame(width: 24, height: 24)
                    
                    Spacer()
                    
                    Text("펫 보관함")
                        .font(.heading6_semibold16)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    Rectangle()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.clear)
                    
                }
                .frame(height: 48)
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
                
                
                HStack {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<9, id: \.self) { index in
                            Rectangle()
                                .fill(Color.gray)
                                .overlay(Text("\(index + 1)").foregroundColor(.white))
                                .aspectRatio(1, contentMode: .fit)
                                .padding(.horizontal, 8)
                        }
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
                GreenButton(action: {
                    print("선택 완료")
                }, title: "선택 완료", disabled: .constant(false))
                .padding(.bottom, 44)
            }
            .navigationBarHidden(true)
        }
    }
}


#Preview {
    PetArchiveView()
}
