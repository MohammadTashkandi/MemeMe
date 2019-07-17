//
//  ViewController.swift
//  MemeMe
//
//  Created by Mohammad Tashkandi on 13/08/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topCaption: UITextField!
    @IBOutlet weak var bottomCaption: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        styleCaption(topCaption, text: "Top")
        styleCaption(bottomCaption, text: "Bottom")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = memeImage.image != nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: Actions
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        pickAnImage(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        pickAnImage(sourceType: .camera)
    }
    
    
    @IBAction func shareAMeme(_ sender: Any) {
        
        let meme = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = { (nil, shared, _, error) in
            if shared {
                self.save()
            }
        }
    }
    
    /*
    @IBAction func resetMeme(_ sender: Any) {
        
        memeImage.image = nil
        
        topCaption.text = "Top"
        bottomCaption.text = "Bottom"
        
        topCaption.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        bottomCaption.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        
        shareButton.isEnabled = false
    }
 */
    
    @IBAction func cancelMeme(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeFont(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Change Font", message: "Choose the font you want to use", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "ChalkboardSE-Bold", style: .default, handler: {_ in
            self.changeCaptionFont(font: "ChalkboardSE-Bold")
        }))
        
        alertController.addAction(UIAlertAction(title: "Copperplate", style: .default, handler: {_ in
            self.changeCaptionFont(font: "Copperplate")
        }))
        
        alertController.addAction(UIAlertAction(title: "AmericanTypewriter", style: .default, handler: {_ in
            self.changeCaptionFont(font: "AmericanTypewriter")
        }))
        
        alertController.addAction(UIAlertAction(title: "Baskerville-SemiBoldItalic", style: .default, handler: {_ in
            self.changeCaptionFont(font: "Baskerville-SemiBoldItalic")
        }))
        
        alertController.addAction(UIAlertAction(title: "HelveticaNeue-CondensedBlack",  style: .default, handler: {_ in
            self.changeCaptionFont(font: "HelveticaNeue-CondensedBlack")
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Custom methods
    
    func changeCaptionFont(font: String) {
        topCaption.font = UIFont(name: font, size: 40)
        bottomCaption.font = UIFont(name: font, size: 40)
    }
    
    func styleCaption(_ caption: UITextField, text: String) {
        caption.delegate = self
        caption.text = text
        caption.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        caption.defaultTextAttributes = memeTextAttributes
        caption.textAlignment = .center
    }
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -4.0
    ]
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        
        if bottomCaption.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    @objc func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save() {

        let meme = Meme(topCaption: topCaption.text!, bottomCaption: bottomCaption.text!, origialImage: memeImage.image!, memedImage: generateMemedImage())
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        print("meme appended")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        navBar.isHidden = true
        toolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    // MARK: implementing Delegates
    
    // --Image picker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            memeImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    // --Text field
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "Top" || textField.text == "Bottom" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

