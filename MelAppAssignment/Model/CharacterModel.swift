//
//  CharacterModel.swift
//  MelAppAssignment
//
//  Created by Prabhat on 11/12/20.
//  Copyright © 2020 prabhat. All rights reserved.
//

import Foundation
import UIKit

struct Characters {
  let id : Int
  let name: String
  let description: String?
  let characterImage: String

  init(id: Int, name: String, description: String?, image: String) {
    self.id = id
    self.name = name
    self.description = description
    self.characterImage = image
  }
}



/*

 Thor Odinson is the All-father of Asgard /God of Thunder, offspring of All-Father Odin & the Elder Earth-Goddess Gaea. Combining the powers of both realms makes him an elder-god hybrid and a being of limitless potential. Armed with his enchanted Uru hammer Mjolnir which helps him to channel his godly energies. The mightiest and the most beloved warrior in all of Asgard, a staunch ally for good and one of the most powerful beings in the multiverse/omniverse. Thor is also a founding member of the Avengers.
 */
