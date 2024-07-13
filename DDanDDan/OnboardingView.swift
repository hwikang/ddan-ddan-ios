//
//  OnboardingView.swift
//  DDanDDan
//
//  Created by paytalab on 6/28/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPageIndex: Int = 0
    private let pageItemList: [OnboardingItem] = [
        .init(title: "오늘 소비한 칼로리로\n귀여운 펫을 키워보세요", desc: "desc1", imageName: "image1"),
        .init(title: "펫이 다 자라면\n또 다른 펫을 키울 수 있어요", desc: "desc2", imageName: "image2"),
        .init(title: "꾸준히 운동해\n소중한 펫을 지켜주세요!", desc: "desc3", imageName: "image3")
    ]
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
                    HealthKitManager.shared.requestAuthorization { isEnable in
                        if isEnable {
                            HealthKitManager.shared.readActiveEnergyBurned { energy in
                                print(energy)
                            }
                        }
                    }

                } label: {
                    Text("시작하기")
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(Color(red: 19/255, green: 230/255, blue: 149/255))
                        .foregroundColor(.black)
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
