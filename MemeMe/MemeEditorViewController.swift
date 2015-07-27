//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Marius Horga on 7/25/15.
//  Copyright © 2015 Marius Horga. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    var memedImage: UIImage?
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let memeTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : 2.0
        ]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        topTextField.textAlignment = .Center
        topTextField.delegate = self
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .Center
        bottomTextField.delegate = self
        (imagePickerView.image != nil) ? (shareButton.enabled = true) : (shareButton.enabled = false)
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) ? (cameraButton.enabled = true) : (cameraButton.enabled = false)
        subscribeToKeyboardShowNotifications()
        subscribeToKeyboardHideNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.save()
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        navigationController?.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage!)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        navigationController?.navigationBarHidden = true
        toolBar.hidden = true
        tabBarController?.tabBar.hidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        navigationController?.navigationBarHidden = false
        toolBar.hidden = false
        return memedImage
    }
    
    func subscribeToKeyboardShowNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardHideNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        setTheImagePicker(.PhotoLibrary)
    }
    
    @IBAction func takeCameraShot(sender: UIBarButtonItem) {
        setTheImagePicker(.Camera)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setTheImagePicker(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == topTextField && topTextField.text == "TOP") || (textField == bottomTextField && bottomTextField.text == "BOTTOM") {
            textField.text = nil
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
