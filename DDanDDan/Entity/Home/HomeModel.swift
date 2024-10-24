//
//  HomeModel.swift
//  DDanDDan
//
//  Created by 이지희 on 9/26/24.
//

import SwiftUI

struct HomeModel {
  var petType: PetType
  var goalKcal: Int
  var feedCount: Int
  var toyCount: Int
  var level: Int
}

struct HomeKcalModel {
    var currentKcal: Int
    var level: Int 
}


enum PetType {
  case pinkCat
  case greenHam
  case purpleDog
  case bluePenguin
}

struct ListItem {
  let image: Image
  let title: String
  let content: String
}
