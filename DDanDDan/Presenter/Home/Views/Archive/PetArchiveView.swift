//
//  PetArchiveView.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI

struct PetArchiveView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject var viewModel: PetArchiveViewModel

    @State private var showToast = false
    
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
                        coordinator.pop()
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
                                ZStack {
                                    let pet = viewModel.petList[safe: index]
                                    
                                    // UserDefaults에서 저장된 petId와 비교하여 border 색상 설정
                                    RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                                        .stroke(viewModel.selectedIndex == index ? Color.buttonGreen : Color.clear, lineWidth: 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8).foregroundColor(.borderGray)
                                        )
                                        .frame(maxWidth: 100, maxHeight: 100)
                                    
                                    if let pet = pet {
                                        pet.type.image(for: pet.level)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 100, maxHeight: 100)
                                    } else {
                                        Image(.questionMark)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 48, height: 48)
                                            .padding(24)
                                    }
                                }
                                .onTapGesture {
                                    viewModel.toggleSelection(for: index)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                Spacer()
                GreenButton(action: {
                    if !viewModel.petId.isEmpty {
                        Task {
                            await viewModel.selectMainPet(id: viewModel.petId)
                        }
                        coordinator.pop()
                    } else {
                        showToastMessage()
                    }
                }, title: "선택 완료", disabled: .constant(false))
                .padding(.bottom, 44)
            }
            if showToast {
                VStack {
                    ToastView(message: "새로운 펫을 준비중이에요")
                        .onTapGesture {
                            hideToastMessage() // 탭하면 토스트 사라짐
                        }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .opacity)) // 사라질 때는 페이드 아웃만
                .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3), value: showToast)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 250)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            Task {
                await viewModel.fetchPetArchive()
            }
        }
    }
    
    private func showToastMessage() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            hideToastMessage()
        }
    }
    
    private func hideToastMessage() {
        showToast = false
    }
}


#Preview {
    PetArchiveView(coordinator: AppCoordinator(), viewModel: PetArchiveViewModel(repository: HomeRepository()))
}
