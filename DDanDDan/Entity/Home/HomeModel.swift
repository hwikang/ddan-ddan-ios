//
//  HomeModel.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI

struct HomeModel {
    var petType: PetType
    var level: Int
    var exp: Double
    var goalKcal: Int
    var feedCount: Int
    var toyCount: Int
}

struct WatchPetModel: Codable {
    var petType: PetType
    var goalKcal: Int
    var level: Int
}

public enum PetType: String, Codable {
    case pinkCat = "CAT"
    case greenHam = "HAMSTER"
    case purpleDog = "DOG"
    case bluePenguin = "PENGUIN"
    
    
    
    var backgroundImage: Image {
        switch self {
        case .pinkCat: return Image(.pinkBackground).resizable()
        case .greenHam: return Image(.greenBackground).resizable()
        case .purpleDog: return Image(.purpleBackground).resizable()
        case .bluePenguin: return Image(.blueBackground).resizable()
        }
    }
    
    var color: Color  {
        switch self {
        case .pinkCat: return .pinkGraphics
        case .greenHam: return .greenGraphics
        case .purpleDog: return .purpleGraphics
        case .bluePenguin: return .blueGraphics
        }
    }
    
    func image(for level: Int) -> Image {
        switch (self, level) {
        case (.pinkCat, 1): return Image(.pinkEgg).resizable()
        case (.pinkCat, 2): return Image(.pinkLv1).resizable()
        case (.pinkCat, 3): return Image(.pinkLv2).resizable()
        case (.pinkCat, 4): return Image(.pinkLv3).resizable()
        case (.pinkCat, 5): return Image(.pinkLv4).resizable()
            
        case (.greenHam, 1): return Image(.greenEgg).resizable()
        case (.greenHam, 2): return Image(.greenLv1).resizable()
        case (.greenHam, 3): return Image(.greenLv2).resizable()
        case (.greenHam, 4): return Image(.greenLv3).resizable()
        case (.greenHam, 5): return Image(.greenLv4).resizable()
            
        case (.bluePenguin, 1): return Image(.blueEgg).resizable()
        case (.bluePenguin, 2): return Image(.blueLv1).resizable()
        case (.bluePenguin, 3): return Image(.blueLv2).resizable()
        case (.bluePenguin, 4): return Image(.blueLv3).resizable()
        case (.bluePenguin, 5): return Image(.blueLv4).resizable()
            
        case (.purpleDog, 1): return Image(.purpleEgg).resizable()
        case (.purpleDog, 2): return Image(.purpleLv1).resizable()
        case (.purpleDog, 3): return Image(.purpleLv2).resizable()
        case (.purpleDog, 4): return Image(.purpleLv3).resizable()
        case (.purpleDog, 5): return Image(.purpleLv4).resizable()
            
        default: return Image(.pinkEgg).resizable() // 기본 이미지
        }
    }
}

struct ListItem {
    let image: Image
    let title: String
    let content: String
}

enum bubbleTextType {
    case success
    case failure
    case normal
    case eat
    case play
    
    func getRandomText() -> [String] {
        switch self {
        case .success:
            return ["오늘도 잘 먹었군", "득근득근", "벌컵벌컵"]
        case .failure:
            return ["앗 근손실", "혼내준다", "지방이 늘어나요"]
        case .normal:
            return ["안녕", "배고파요", "운동하자"]
        case .eat:
            return ["맛있다!", "욤뇸뇸", "쩝쩝박사"]
        case .play:
            return ["신난다!", "조아조아", "눈누난나 ♫"]
        }
    }
}
