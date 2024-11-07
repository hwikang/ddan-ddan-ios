//
//  DeleteUserConfirmView.swift
//  DDanDDan
//
//  Created by hwikang on 10/14/24.
//

import SwiftUI

struct DeleteUserConfirmView: View {
    @ObservedObject var viewModel: DeleteUserViewModel
    @Binding public var path: [SettingPath]
    public let selectedReason: Set<String>
    var body: some View {
        
        ZStack {
            Color.backgroundBlack.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text(viewModel.name + "님\n탈퇴하기 전에 확인해주세요")
                    .font(.heading3_bold24)
                    .lineSpacing(8)
                    .foregroundStyle(.white)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                Text("딴딴에서 함께했던 펫들과 운동기록을\n다시 볼 수 없어요.")
                    .font(.body1_regular16)
                    .lineSpacing(8)
                    .foregroundStyle(.iconGray)
                    .padding(.top, 8)
                    .padding(.horizontal, 20)

                Image("deleteUser").frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                GreenButton(action: {
                    Task {
                        if await viewModel.deleteUser(reason: selectedReason) {
                            path.removeAll()
                        }
                    }
                }, title: "탈퇴하기", disabled: .constant(selectedReason.isEmpty))
            }
        }
    }
    
}

#Preview {
    DeleteUserConfirmView(viewModel: DeleteUserViewModel(), path: .constant([]), selectedReason: [])
}
