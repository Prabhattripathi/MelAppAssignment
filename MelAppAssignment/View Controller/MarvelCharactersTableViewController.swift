//
//  MarvelCharactersTableViewController.swift
//  MelAppAssignment
//
//  Created by Prabhat on 10/12/20.
//  Copyright © 2020 prabhat. All rights reserved.
//

import UIKit
import SVProgressHUD

let cellIdentifier = "characterCell"

class MarvelCharactersTableViewController: UITableViewController {
  var charactersData = [Characters]()
  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    getCharactersData()
    tableView.reloadData()
  }

  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

    self.present(alertController, animated: true, completion: nil)
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return charactersData.count
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MarvelCharacterTableViewCell
    cell.characterImageView.image = UIImage(named: "spider-man")
    cell.characterNamelabel.text = charactersData[indexPath.row].name
    cell.characterDescriptionLabel.text = charactersData[indexPath.row].description
    let imageData = charactersData[indexPath.row].characterImage
    if  let data =  Data(base64Encoded: imageData) {
      if let characterImage = UIImage(data: data){
        cell.characterImageView.image = characterImage
      } else {
        cell.characterImageView.image = UIImage(named: "no_image")
      }
    }

    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      print(charactersData[indexPath.row].id)
      //let characterID = charactersData[indexPath.row].id
      DBManager.shared.deleteEntryFromDatabase(id: charactersData[indexPath.row].id) { (isSuccess, error) in
        if isSuccess {
          charactersData.remove(at: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
          self.showAlert(title: "Error.!", message: "Error deleting character")
        }
      }
    }
  }
  

  func getCharactersData() {
    DBManager.shared.getData(query: "SELECT * FROM Characters") { (isSuccess, result, error) in
      if isSuccess {
        guard  let results = result else { return }
        charactersData.removeAll()
        while results.next() {
          guard let id = results.string(forColumn: "id") else {
            return
          }
          guard let characterName = results.string(forColumn: "character_name") else {
            return
          }

          guard let characterDescription = results.string(forColumn: "character_description") else {
            return
          }

          guard let characterImage = results.string(forColumn: "character_image") else {
            return
          }

          charactersData.append(Characters(id: Int(id) ?? 0, name: characterName , description: characterDescription , image: characterImage))
        }
        SVProgressHUD.dismiss()
      }
    }
  }


   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
    if segue.identifier == "add" {
      let addCharacter = segue.destination as! AddCharacterViewController
      addCharacter.title = "Add New Character"
    } else {
      guard let indexPath = self.tableView?.indexPathForSelectedRow else { return }
      let editCharacter = segue.destination as! AddCharacterViewController
      let imageData = charactersData[indexPath.row].characterImage
      if  let data =  Data(base64Encoded: imageData) {
        DispatchQueue.main.async {
          editCharacter.title = "Edit Character"
          editCharacter.characterImageView.image = UIImage(data: data)
          editCharacter.characterNameTextField.text = self.charactersData[indexPath.row].name
          editCharacter.characterDescriptionTextView.text = self.charactersData[indexPath.row].description
        }
      }
    }
   }

}
