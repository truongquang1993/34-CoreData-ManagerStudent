//
//  MyViewController.swift
//  3400 CoreData 08
//
//  Created by Trương Quang on 7/15/19.
//  Copyright © 2019 truongquang. All rights reserved.
//

import UIKit
import CoreData

class MyViewController: UIViewController {
    
    @IBOutlet weak var outletImage: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phonenumber: UITextField!
    @IBOutlet weak var address: UITextField!
    
    var inforStudent: InforManager?
    let imagePicker = UIImagePickerController()
    var moc: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillInfor()
        imagePicker.delegate = self
        outletImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        outletImage.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    func fillInfor() {
        if let infor = inforStudent {
            outletImage.image = UIImage(data: infor.image as! Data)
            name.text = infor.name
            phonenumber.text = infor.phonenumber
            address.text = infor.address
        } else {
            outletImage.image = UIImage(named: "nophoto.jpg")
        }
        outletImage.layer.cornerRadius = outletImage.bounds.width / 2
        outletImage.layer.borderWidth = 1
        outletImage.layer.borderColor = UIColor.lightGray.cgColor
        outletImage.layer.masksToBounds = true
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
    
    @IBAction func save(_ sender: Any) {
        guard let imageData = outletImage.image?.pngData() else { return }
        guard let name = name.text?.trimmingCharacters(in: .whitespacesAndNewlines), let phonenumber = phonenumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let address = address.text else { return }
        if !name.isEmpty && !phonenumber.isEmpty {
            guard let moc = self.moc else {return}
            if let inforStudent = inforStudent {
                inforStudent.name = name
                inforStudent.phonenumber = phonenumber
                inforStudent.address = address
                inforStudent.image = imageData as NSData
                NotificationCenter.default.post(name: .passDataVC2, object: inforStudent)
            } else {
                let inforStudent = InforManager(context: moc)
                inforStudent.name = name
                inforStudent.phonenumber = phonenumber
                inforStudent.address = address
                inforStudent.image = imageData as NSData
                NotificationCenter.default.post(name: .passDataVC2, object: inforStudent)
            }
        } else {
            return showAlert(message: "You must input name and phone number")
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (name.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! || (phonenumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
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

extension MyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choose = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        outletImage.image = choose
        dismiss(animated: true, completion: nil)
    }
}
