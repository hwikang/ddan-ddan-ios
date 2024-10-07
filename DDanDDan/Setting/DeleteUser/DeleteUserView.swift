//
//  DeleteUserView.swift
//  DDanDDan
//
//  Created by hwikang on 10/7/24.
//

import SwiftUI

struct DeleteUserView: View {
    @ObservedObject var viewModel: DeleteUserViewModel
    @State var selectedReason: Set<String> = []
    
    var body: some View {
        
        ZStack {
            Color.backgroundBlack.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("탈퇴하는 이유가 무엇인가요?")
                    .font(.heading3_bold24)
                    .lineSpacing(8)
                    .foregroundStyle(.white)
                    .padding(.top, 32)
                    .padding(.horizontal, 20)
                List(viewModel.reasons, id: \.self) { reason in
                    DeleteUserReasonButton(title: reason, isSelected: selectedReason.contains(reason)) {
                        addReason(reason: reason)
                    } .foregroundStyle(.white)
                        .listRowBackground(Color.backgroundBlack)
                }
                .listRowSeparator(.hidden)
                .listStyle(.plain)
                Spacer()
                GreenButton(action: {
                    
                }, title: "탈퇴하기", disabled: .constant(selectedReason.isEmpty))
            }
        }
    }
    
    private func addReason(reason: String) {
        if selectedReason.contains(reason) {
            selectedReason.remove(reason)
        } else {
            selectedReason.insert(reason)
        }
    }
}

struct DeleteUserReasonButton: View {
    
    private let title: String, isSelected: Bool
    private let action: () -> Void
    init(title: String, isSelected: Bool,
         action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    var body: some View {
      
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundStyle(.white)
                    .font(.body1_regular16)
                Spacer()
                Image(isSelected ? "checkboxCircleSelected" :"checkboxCircle")
            }
        }

        
    }
}

#Preview {
    DeleteUserView(viewModel: DeleteUserViewModel())
}
