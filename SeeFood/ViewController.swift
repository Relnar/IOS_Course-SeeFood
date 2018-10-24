//
//  ViewController.swift
//  SeeFood
//
//  Created by Pierre-Luc Bruyere on 2018-10-23.
//  Copyright © 2018 Pierre-Luc Bruyere. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
  // MARK: - Attributes

  @IBOutlet weak var imageView: UIImageView!

  let imagePicker = UIImagePickerController()

  // MARK: -

  override func viewDidLoad()
  {
    super.viewDidLoad()

    imagePicker.delegate = self
    imagePicker.allowsEditing = false
  }

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
  {
    if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    {
      imageView.image = userPickedImage
    }

    imagePicker.dismiss(animated: true, completion: nil)
  }

  @IBAction func cameraTapped(_ sender: UIBarButtonItem)
  {
    imagePicker.sourceType = .camera
    present(imagePicker, animated: true, completion: nil)
  }

  @IBAction func photoLibraryTapped(_ sender: UIBarButtonItem)
  {
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true, completion: nil)
  }
}

