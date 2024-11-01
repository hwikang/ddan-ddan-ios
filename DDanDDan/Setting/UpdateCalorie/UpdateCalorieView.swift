//
//  UpdateCalorieView.swift
//  DDanDDan
//
//  Created by hwikang on 9/26/24.
//

import SwiftUI

struct UpdateCalorieView: View {
    @ObservedObject var viewModel: UpdateCalorieViewModel
    @State private var buttonDisabled: Bool = true
    @Binding var path: [SettingPath]

    var body: some View {
        ZStack {
            Color.backgroundBlack.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("하루 목표 칼로리를\n설정해주세요")
                    .font(.neoDunggeunmo24)
                    .lineSpacing(8)
                    .foregroundStyle(.white)
                    .padding(.top, 32)
                    .padding(.horizontal, 20)
                HStack(alignment: .center) {
                    Button {
                        viewModel.increaseCalorie()
                    } label: {
                        Image("plusButtonRounded")
                    }
                    Text(String(viewModel.calorie))
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundStyle(.buttonGreen)
                        .frame(width: 84, height: 80)
                        .background(.backgroundGray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Button {
                        viewModel.decreaseCalorie()
                    } label: {
                        Image("minusButtonRounded")
                    }
                    
                }.frame(maxWidth: .infinity)
                    .padding(.top, 56)
                
                Spacer()
                
                GreenButton(action: {
                    Task {
                        if await viewModel.update() {
                            path.removeLast()
                        }
                    }
                            
                }, title: "변경 완료", disabled: .constant(false))
            }
            
        }
        .navigationTitle("목표 칼로리 수정")
    }

}

#Preview {
    UpdateCalorieView(viewModel: UpdateCalorieViewModel(calorie: 100, repository: SettingRepository()), path: .constant([]))
}
