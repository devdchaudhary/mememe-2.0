//
//  ViewController.swift
//  MemeMe
//
//  Created by Devanshu on 11/04/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import UIKit
import ImageIO

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    // Top Toolbar + Share Button
    
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //Bottom Toolbar + Camera Button
    
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    // Main Function that displays the view
    
    @IBOutlet weak var memeView: UIImageView!
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setTextAttribute(textField: topTextField, str: "TOP")
        setTextAttribute(textField: bottomTextField, str: "BOTTOM")
        
        memeView.backgroundColor = UIColor.black
        
        view.backgroundColor = UIColor.black
                
    }
    
    //Hiding the status Bar
    
    override var prefersStatusBarHidden: Bool {
        
        return true
        
    }
    
    // ViewVillAppear and ViewwillDisappear function necessary for defining whether the keyboard will show up or not, also the share button is hidden until a meme is generated
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        shareButton.isEnabled = memeView.image != nil
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        unsubscribeToKeyboardNotifications()
        
    }
    
    // Show Image Info
    
    @IBAction func showImageInfo(_ sender: Any) {
        
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "tooltipVC") as? ToolTipViewController
        popoverContentController?.modalPresentationStyle = .popover
        
        if let image = memeView.image {
            
            if let metaData = getMetadataFromImage(image) {
                
                let imageData = ImageDataModel(data: metaData)
                popoverContentController?.imageData = imageData
                
            }
        }
            
        /* 3 */
        // Present popover
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = .init(x: self.view.frame.midX - 20, y: 0, width: 50, height: 50)
            popoverPresentationController.delegate = self
            if let popoverController = popoverContentController {
                present(popoverController, animated: true, completion: nil)
            }
            
        }
    }
    
    // Image generation methods
    
    // Function for choosing image
    
    func pickImage(source: UIImagePickerControllerSourceType) {
        
        let cameraAndAlbumImagePicker = UIImagePickerController()
        cameraAndAlbumImagePicker.delegate = self
        cameraAndAlbumImagePicker.allowsEditing = true
        cameraAndAlbumImagePicker.sourceType = source
        present(cameraAndAlbumImagePicker, animated: true, completion: nil)
        
    }
    
    // Album is launched when album button is pressed
    
    @IBAction func albumButtom(_ sender: Any) {
        
        pickImage(source: .photoLibrary)
        
    }
    
    // Camera is launched when camera button is pressed
    
    @IBAction func cameraButton(_ sender: Any) {
        
        pickImage(source: .camera)
        
    }
    
    // Function that tells the imageview to show the picked image by the user
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedimage = info[UIImagePickerControllerOriginalImage] as! UIImage
        memeView.image = pickedimage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // All Keyboard and Text Generation Methods
    
    // Text fields outline attribute
    
    let textattributes = [
        
        NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
        NSAttributedStringKey.font.rawValue : UIFont(name: "Impact", size: 50)!,
        NSAttributedStringKey.strokeWidth.rawValue : NSNumber(value: -4.0)
        
        ] as [String: Any]
    
    func setTextAttribute(textField : UITextField, str : String) {
        textField.delegate = self
        textField.text = str
        textField.defaultTextAttributes = textattributes
        textField.textAlignment = .center
    }
    
    // Function for activating the return button on the keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    // Function for sending the notification for enabling the keyboard
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // Function for moving the frame up is keyboard is called
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
    }
    
    // Function for determining the keyboard height and sending that as a notification to KeyboardWillShow function
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardsize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardsize.cgRectValue.height
        
    }
    
    // Function for sending the notification for disabling the keyboard
    
    func unsubscribeToKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
    // Function for hiding the keyboard once it's done getting used
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        view.frame.origin.y = 0
        
    }
    
    // Saving the meme
    
    func save() {
        
        // Creating the meme
        let memedImage = generateMemedImage()

        let meme = Meme(topText: topTextField.text!, botText: bottomTextField.text!, originalImage: memeView.image!, memedImage: memedImage)
        
        debugPrint("Save Complete")
        
        // Sending the meme to the shared model
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    //Saving the generated memed image and passing it as a UIImage
    
    func generateMemedImage() -> UIImage {
        
        topBar.isHidden = true
        
        bottomBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                        
        UIGraphicsEndImageContext()
        
        topBar.isHidden = false
        
        bottomBar.isHidden = false
        
        debugPrint("Meme Generated")
        
        return memedImage
        
    }
    
    func getMetadataFromImage(_ image: UIImage) -> [String: Any]? {
        
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else {
            return nil
        }
        
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return nil
        }
        
        guard let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any] else {
            return nil
        }
        
        return metadata
    }
    
    // Sharing Method
    
    @IBAction func sharememe(sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.completionWithItemsHandler = {activity, completed, items, error in
            
            self.save()
            
            self.dismiss(animated: true, completion: nil)
            
            if completed {
                
                self.shareButton.isEnabled = true
                
                debugPrint("Share Complete")
                
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    // Cancel Action
    
    @IBAction func cancelAction(sender: AnyObject) {
    
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        self.memeView.image = nil
    
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
}
