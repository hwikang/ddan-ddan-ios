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


public enum PetType: String, Decodable {
  case pinkCat = "CAT"
  case greenHam = "HAMSTER"
  case purpleDog = "DOG"
  case bluePenguin = "PENGUIN"
}

struct ListItem {
  let image: Image
  let title: String
  let content: String
}
