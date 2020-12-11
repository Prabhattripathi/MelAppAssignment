//
//  AppDelegate.swift
//  MelAppAssignment
//
//  Created by Prabhat on 10/12/20.
//  Copyright © 2020 prabhat. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    SVProgressHUD.setDefaultStyle(.dark)
    SVProgressHUD.setDefaultMaskType(.black)

    let font = UIFont (name: "ChalkboardSE-Regular", size: 17)
    let attributes: [NSAttributedString.Key: Any] = [
      .font : font as Any,
      .foregroundColor: UIColor.white
    ]
    UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)

    let navigationAppearance = UINavigationBar.appearance()

    navigationAppearance.tintColor = UIColor.white
    navigationAppearance.barTintColor = UIColor.rgb(r: 41, g: 41, b: 92)

    navigationAppearance.titleTextAttributes = attributes

    createDatabase()

    return true
  }

  private func createDatabase () {
    DBManager.shared.createDatabase(createTableQuery: "CREATE TABLE 'Characters' (id integer PRIMARY KEY NOT NULL, 'character_name' varchar, 'character_description' varchar, 'character_image' blob, UNIQUE (character_name) ON CONFLICT replace)")
    
    insertCharactersData()
  }

  private func insertCharactersData () {
    SVProgressHUD.show(withStatus: "Loading")
    let spiderMan = Characters(id: 0, name: "Spider-Man", description: #"Peter Parker was bitten by a radioactive spider as a teenager, granting him spider-like powers. After the death of his Uncle Ben, Peter learned that "with great power, comes great responsibility." Swearing to always protect the innocent from harm, Peter Parker became Spider-Man."#, image: createImageData(imageName: "spider-man"))

    let thor = Characters(id: 0, name: "Thor", description: "Thor Odinson is the All-father of Asgard /God of Thunder, offspring of All-Father Odin & the Elder Earth-Goddess Gaea. Combining the powers of both realms makes him an elder-god hybrid and a being of limitless potential. Armed with his enchanted Uru hammer Mjolnir which helps him to channel his godly energies. The mightiest and the most beloved warrior in all of Asgard, a staunch ally for good and one of the most powerful beings in the multiverse/omniverse. Thor is also a founding member of the Avengers.", image: createImageData(imageName: "thor"))

    let ironMan = Characters(id: 0, name: "Iron Man", description: "Tony Stark was the arrogant son of wealthy, weapon manufacturer Howard Stark. Tony cared only about himself, but he would have a change of heart after he was kidnapped by terrorists and gravely injured. Pressured to create a weapon of mass destruction, Stark instead created a suit of armor powerful enough for him to escape. Tony uses his vast resources and intellect to make the world a better place as The Invincible Iron Man. Stark's super hero identity led him to become a founding member of the Avengers.", image: createImageData(imageName: "iron-man"))

    let captainaAmerica = Characters(id: 0, name: "Captain America", description: "During World War II, Steve Rogers volunteered to receive the experimental Super-Soldier Serum. Enhanced to the pinnacle of human physical potential and armed with an unbreakable shield, he became Captain America. After a failed mission left him encased in ice for decades, he was found and revived by the Avengers, later joining their ranks and eventually becoming the team's leader.", image: createImageData(imageName: "captain-america"))

    let blackPanther = Characters(id: 0, name: "Black Panther", description: "T'sChalla is the Black Panther, king of Wakanda, one of the most technologically advanced nations on Earth. He is among the top intellects and martial artists of the world, a veteran Avenger, and a member of the Illuminati. Using his powers and abilities, he has pledged his fortune, powers, and life to the service of all mankind.", image: createImageData(imageName: "black-panther"))

    let doctorStrange = Characters(id: 0, name: "Doctor Strange", description: "Dr. Stephen Strange was once a gifted but egotistical surgeon who sought out the Ancient One to heal his hands after they were wounded in a car accident. Instead, the Ancient One trained him to become Master of the Mystic Arts and the Sorcerer Supreme of Earth.", image: createImageData(imageName: "doctor-strange"))

    let wolverine = Characters(id: 0, name: "Wolverine", description: #"A long-lived mutant with the rage of a beast and the soul of a Samurai, James "Logan" Howlett's once mysterious past is filled with blood, war and betrayal. Possessing an accelerated healing factor, keenly enhanced senses and bone claws in each hand (along with his skeleton) that are coated in adamantium; Wolverine is, without question, the ultimate weapon."#, image: createImageData(imageName: "wolverine"))

    let hulk = Characters(id: 0, name: "Hulk", description: "After being bombarded with a massive dose of gamma radiation while saving a young man's life during an experimental bomb testing, Dr. Robert Bruce Banner was transformed into the Incredible Hulk: a green behemoth who is the living personification of rage and pure physical strength.", image: createImageData(imageName: "hulk"))

    let antman = Characters(id: 0, name: "Ant Man", description: "Scott Lang was the second man to take up the mantle of Ant-Man. He has been a member of the Avengers and the Fantastic Four.", image: createImageData(imageName: "ant-man"))


    let marvelCharacters = [captainaAmerica, ironMan, thor, hulk, spiderMan, blackPanther, antman, doctorStrange, wolverine]

    marvelCharacters.forEach { (character) in

      DBManager.shared.inserDatabase(insertTableQuery: "INSERT OR REPLACE INTO 'Characters' (character_name, character_description, character_image) VALUES ('\(character.name)', '\(character.description?.replace(target: "'", withString: "`") ?? "")', '\(character.characterImage)')", compliting: {
        (isInsert, error) in
        if isInsert {
          print("entry inserted")
        }
      })
    }

    SVProgressHUD.dismiss()
  }


  // MARK: UISceneSession Lifecycle

//  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//  }
//
//  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//  }


}

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension String
{
  func replace(target: String, withString: String) -> String
  {
    return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
  }
}

func createImageData (imageName:String) -> String {
  let image : UIImage = UIImage(named:imageName)!

  let imageData = image.pngData()!

  let base64String = imageData.base64EncodedString()

  return base64String
}
