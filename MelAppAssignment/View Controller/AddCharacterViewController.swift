//
//  AddCharacterViewController.swift
//  MelAppAssignment
//
//  Created by Prabhat on 11/12/20.
//  Copyright © 2020 prabhat. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddCharacterViewController: UIViewController {
  @IBOutlet weak var characterImageView: UIImageView!
  @IBOutlet weak var characterNameTextField: UITextField!
  @IBOutlet weak var characterDescriptionTextView: UITextView! {
    didSet {
      self.characterDescriptionTextView.layer.cornerRadius = 5
      self.characterDescriptionTextView.layer.borderWidth = 1.5
      self.characterDescriptionTextView.layer.borderColor = UIColor.rgb(r: 41, g: 41, b: 92).cgColor
    }
  }
  @IBOutlet weak var scrollView: UIScrollView!
  var characterDescription: String = ""
  var scrollOffset : CGFloat = 0
  var distance : CGFloat = 0
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    self.characterDescriptionTextView.delegate = self
    if title == "Add New Character" {
      self.characterDescriptionTextView.text = "Enter character's description (Optional)"
      self.characterDescriptionTextView.textColor = UIColor.lightGray
    }

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
    tapGesture.numberOfTapsRequired = 1
    self.scrollView.addGestureRecognizer(tapGesture)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }

  @objc func hideKeyBoard () {
    self.characterDescriptionTextView.resignFirstResponder()
    self.characterNameTextField.resignFirstResponder()
  }


  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  @IBAction func addCharacteData(_ sender: UIButton) {

    let alert = UIAlertController(title: "Add", message: "Character's Image", preferredStyle: .actionSheet)

    let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
      if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
      }
    }

    let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
      } else {
        self.showAlert(title: "Error.", message: "No camera found")
      }
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

    alert.addAction(galleryAction)
    alert.addAction(cameraAction)
    alert.addAction(cancelAction)

    self.present(alert, animated: true, completion: nil)

  }

  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

      var safeArea = self.view.frame
      safeArea.size.height += scrollView.contentOffset.y
      safeArea.size.height -= keyboardSize.height + (UIScreen.main.bounds.height*0.04) // Adjust buffer to your liking

      // determine which UIView was selected and if it is covered by keyboard

      let activeField: UIView? = [self.characterNameTextField, self.characterDescriptionTextView].first { $0.isFirstResponder }
      if let activeField = activeField {
        if safeArea.contains(CGPoint(x: 0, y: activeField.frame.maxY)) {
          print("No need to Scroll")
          return
        } else {
          distance = activeField.frame.maxY - safeArea.size.height
          scrollOffset = scrollView.contentOffset.y
          self.scrollView.setContentOffset(CGPoint(x: 0, y: scrollOffset + distance), animated: true)
        }
      }
      // prevent scrolling while typing

      scrollView.isScrollEnabled = false
    }
  }
  @objc func keyboardWillHide(notification: NSNotification) {
    if distance == 0 {
      return
    }
    // return to origin scrollOffset
    self.scrollView.setContentOffset(CGPoint(x: 0, y: scrollOffset), animated: true)
    scrollOffset = 0
    distance = 0
    scrollView.isScrollEnabled = true
  }

  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

    self.present(alertController, animated: true, completion: nil)
  }

  @IBAction func uploadCharacterData(_ sender: UIButton) {

    if characterNameTextField.text!.isEmpty {
      showAlert(title: "Alert.!", message: "Please enter character name before saving")
    }

    if characterDescriptionTextView.text.contains("Enter character's description (Optional)") {
      characterDescription = "NA"
    } else {
      characterDescription = characterDescriptionTextView.text
    }

    var query = "INSERT OR REPLACE INTO 'Characters' (character_name, character_description, character_image) VALUES ('\(self.characterNameTextField.text ?? "NA")', '\(characterDescription)', "
    

    if characterImageView.image != nil {
      query += "'\(self.characterImageView.image?.pngData()?.base64EncodedString() ?? "")')"
    } else {
      query += "'\(UIImage(named: "no_image")?.pngData()?.base64EncodedString() ?? "")')"
    }

    SVProgressHUD.show(withStatus: "Saving your character")
    DBManager.shared.inserDatabase(insertTableQuery: query) { (isInserted, error) in
      if isInserted {
        SVProgressHUD.dismiss()
        SVProgressHUD.show(withStatus: "Successfuly saved your character")
        self.navigationController?.popViewController(animated: true)
      }
    }
    

    //Characters(name: "Ant Man", description: "Scott Lang was the second man to take up the mantle of Ant-Man. He has been a member of the Avengers and the Fantastic Four.", image: createImageData(imageName: "ant-man"))
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.characterDescriptionTextView.resignFirstResponder()
  }
}


extension AddCharacterViewController: UIImagePickerControllerDelegate {

  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    //        self.pickerController(picker, didSelect: nil)
  }

  public func imagePickerController(_ picker: UIImagePickerController,
                                    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let image = info[.editedImage] as? UIImage else {
      return
    }

    picker.dismiss(animated: true) {
      //      let imageURL = info[.imageURL] as? URL
      //      self.imageName = imageURL?.lastPathComponent
      self.characterImageView.image = image
    }
    //        self.pickerController(picker, didSelect: image)
  }
}

extension AddCharacterViewController: UINavigationControllerDelegate {

}

extension AddCharacterViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
}

extension AddCharacterViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if title == "Add New Character" {
      if textView.textColor == UIColor.lightGray {
        textView.text = nil
        textView.textColor = UIColor.black
      }
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    if title == "Add New Character" {
      if textView.text.isEmpty {
        textView.text = "Enter character's description (Optional)"
        textView.textColor = UIColor.lightGray
      }
    }
  }
}

