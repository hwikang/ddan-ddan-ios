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
    
    @State private var selectedIndex: Int? = nil
    @State private var showToast = false
    
    init(viewModel: PetArchiveViewModel, coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
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
                                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                                    .stroke(selectedIndex == index ? Color.buttonGreen : Color.clear, lineWidth: 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8).foregroundColor(.borderGray) // 배경색 적용
                                    )
                                    .frame(maxWidth: 100, maxHeight: 100)
                                
                                if index < viewModel.PetList.count {
                                    viewModel.characterImage(petType: viewModel.PetList[index].type, level: viewModel.PetList[index].level)
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
                                toggleSelection(for: index)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
                GreenButton(action: {
                    print("선택 완료")
                    showToastMessage()
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
    }
    

    private func toggleSelection(for index: Int) {
        if selectedIndex == index {
            selectedIndex = nil // 이미 선택된 경우 선택 해제
        } else {
            selectedIndex = index // 새로운 인덱스를 선택
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
    PetArchiveView(viewModel: PetArchiveViewModel(repository: HomeRepository()), coordinator: AppCoordinator())
}
