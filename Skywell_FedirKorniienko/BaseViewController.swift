//
//  BaseViewController.swift
//  Skywell_FedirKorniienko
//
//  Created by Fedir Korniienko on 03.06.17.
//  Copyright © 2017 fedir. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var pickerDelegate: PickerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func createPickerToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = UIColor.blue

        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    func donePicker (sender:UIBarButtonItem){
        pickerDelegate?.donePicker(sender: sender)
    }
    
    func cancelPicker (sender:UIBarButtonItem){
        pickerDelegate?.cancelPicker(sender: sender)
    }
}
