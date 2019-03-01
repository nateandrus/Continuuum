//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Nathan Andrus on 2/27/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var selectImageButtonLabel: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captionTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        guard let tabBarController = self.navigationController?.parent as? UITabBarController else { return }
        DispatchQueue.main.async {
            tabBarController.selectedIndex = 0
        }
        captionTextField.text = ""
        selectedImage = nil
    }
    

    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        if let postImage = selectedImage, let captionText = captionTextField.text, !captionText.isEmpty {
        PostController.shared.createPostWith(image: postImage, caption: captionText) { (newPost) in
        }
        guard let tabBarController = self.navigationController?.parent as? UITabBarController else { return }
        DispatchQueue.main.async {
            tabBarController.selectedIndex = 0
            }
        } else {
            let alertController = UIAlertController(title: "Missing Picture or Caption", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Alright", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContainerVC" {
            let photoSelector = segue.destination as? PhotoSelectorViewController
            photoSelector?.delegate = self
        }
    }
}

extension AddPostTableViewController: PhotoSelectorViewControllerDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        selectedImage = image
    }
}

