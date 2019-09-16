//
//  DetailViewController.swift
//  StudentManagerSimpleApp
//
//  Created by Trương Quang on 9/16/19.
//  Copyright © 2019 truongquang. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var address: UITextField!
    
    var inforContact: InforContact?
    let imagePicker = UIImagePickerController()
    var moc: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillInfor()
        imagePicker.delegate = self
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        avatar.addGestureRecognizer(tapGesture)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSave))
    }
    
    override func viewDidLayoutSubviews() {
        avatar.layer.cornerRadius = avatar.bounds.width / 2
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = UIColor.lightGray.cgColor
        avatar.layer.masksToBounds = true
    }
    
    func fillInfor() {
        if let infor = inforContact {
            if let data = inforContact?.image as Data? {
                avatar.image = UIImage(data: data)
            }
            name.text = infor.name
            phoneNumber.text = infor.phoneNumber
            address.text = infor.address
        } else {
            avatar.image = UIImage(named: "nophoto.jpg")
        }
    }
    
    @objc func addPhoto() {
        let alertController = UIAlertController(title: "Choose from", message: nil, preferredStyle: .actionSheet)
        
        //From Camera
        let fromCamera = UIAlertAction(title: "From camera", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                self.showAlert(message: "Device is not support camera")
            }
        }
        
        //from library
        let fromLibrary = UIAlertAction(title: "From library", style: .default) { (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(fromCamera)
        alertController.addAction(fromLibrary)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func didTapSave(_ sender: UIBarButtonItem) {
        guard let imageData = avatar.image?.pngData() else { return }
        guard let name = name.text?.trimmingCharacters(in: .whitespacesAndNewlines), let phonenumber = phoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let address = address.text else { return }
        if !name.isEmpty && !phonenumber.isEmpty {
            guard let moc = self.moc else {return}
            if let inforContact = inforContact {
                inforContact.name = name
                inforContact.phoneNumber = phonenumber
                inforContact.address = address
                inforContact.image = imageData as NSData
                NotificationCenter.default.post(name: .passDataFromDetailVC, object: inforContact)
            } else {
                let inforContact = InforContact(context: moc)
                inforContact.name = name
                inforContact.phoneNumber = phonenumber
                inforContact.address = address
                inforContact.image = imageData as NSData
                NotificationCenter.default.post(name: .passDataFromDetailVC, object: inforContact)
            }
        } else {
            return showAlert(message: "You must input name and phone number")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (name.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! || (phoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return false
        } else {
            return true
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choose = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        avatar.image = choose
        dismiss(animated: true, completion: nil)
    }
}
