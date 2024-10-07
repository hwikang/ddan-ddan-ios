//
//  OnboardingView.swift
//  DDanDDan
//
//  Created by hwikang on 6/28/24.
//

import SwiftUI
import HealthKit

struct OnboardingView: View {
    @State private var currentPageIndex: Int = 0
    @State private var showAuthDialog = false
    @State private var showSignup = false
    
    private let pageItemList: [OnboardingItem] = [
        .init(title: "오늘 소비한 칼로리로\n귀여운 펫을 키워보세요", desc: "desc1", imageName: "image1"),
        .init(title: "펫이 다 자라면\n또 다른 펫을 키울 수 있어요", desc: "desc2", imageName: "image2"),
        .init(title: "꾸준히 운동해\n소중한 펫을 지켜주세요!", desc: "desc3", imageName: "image3")
    ]
    
    init() {
        UserDefaultValue.needToShowOnboarding = false
    }
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                TabView(selection: $currentPageIndex) {
                    ForEach(pageItemList, id: \.self) { item in
                        OnboardingItemView(item: item)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                Button {
                    
                    if UserDefaultValue.requestAuthDone {
                        showSignup.toggle()
                    } else {
                        showAuthDialog.toggle()
                    }
                    
                } label: {
                    Text("시작하기")
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(Color(red: 19/255, green: 230/255, blue: 149/255))
                        .foregroundColor(.black)
                }
                .fullScreenCover(isPresented: $showAuthDialog, content: {
                    DialogView(show: $showAuthDialog, title: "위치 권한을 허용해주세요", description: "지역 기반 기능 사용 시 위치 권한이 필요합니다.", rightButtonTitle: "허용", leftButtonTitle: "허용안함") {
                        HealthKitManager.shared.requestAuthorization { isEnable in
                            if isEnable {
                                UserDefaultValue.requestAuthDone = true
                                showSignup.toggle()
                                HealthKitManager.shared.readActiveEnergyBurned { energy in
                                    print(energy)
                                }
                            }
                        }
                        
                    }
                })
                .fullScreenCover(isPresented: $showSignup) {
                    SignUpView()
                }
                .background(Color.clear)
                .transaction { transaction in
                    transaction.disablesAnimations = true
                }
                .padding(.bottom, 1)
            }
        }
        
    }
}

#Preview {
    OnboardingView()
}

struct OnboardingItem: Hashable {
    public let title: String, desc: String, imageName: String
    init(title: String, desc: String, imageName: String) {
        self.title = title
        self.desc = desc
        self.imageName = imageName
    }
}

struct OnboardingItemView: View {
    private let item: OnboardingItem
    init(item: OnboardingItem) {
        self.item = item
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(item.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.top, 48)
            Text(item.desc)
                .font(.title3)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
            
            Spacer()
            HStack {
                Spacer()
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 280, height: 280)
                Spacer()
            }
            Spacer()
            
            
        }
    }
}
