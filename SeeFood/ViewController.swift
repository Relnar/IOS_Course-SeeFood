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

  // MARK: - CoreML functionality

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
  {
    if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    {
      imageView.image = userPickedImage

      guard let ciimage = CIImage(image: userPickedImage)
      else
      {
        fatalError("Could not convert to CIImage")
      }

      detect(image: ciimage)
    }

    imagePicker.dismiss(animated: true, completion: nil)
  }

  func detect(image: CIImage)
  {
    guard let model = try? VNCoreMLModel(for: Inceptionv3().model)
    else
    {
      fatalError("Loading CoreML Model Failed")
    }

    let request = VNCoreMLRequest(model: model)
    { (request, error) in
      guard let results = request.results as? [VNClassificationObservation]
      else
      {
        fatalError("Could not convert results to VNClassificationObservation")
      }

      if let firstResult = results.first
      {
        if firstResult.identifier.contains("hotdog")
        {
          self.navigationItem.title = "Hot Dog !!"
        }
        else
        {
          self.navigationItem.title = firstResult.identifier
        }
      }
    }

    let handler = VNImageRequestHandler(ciImage: image)
    do
    {
      try handler.perform([request])
    }
    catch
    {
      fatalError("VNImageRequestHandler error")
    }
  }

  // MARK: - Navigation bar buttons

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

