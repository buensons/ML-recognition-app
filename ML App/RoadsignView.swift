//
//  RoadsignView.swift
//  GitHub Networking Test
//
//  Created by Damian Roszczyk on 16/06/2020.
//  Copyright © 2020 Damian Roszczyk. All rights reserved.
//


import Foundation
import UIKit

class RoadsignViewController: UIViewController, ImagePickerDelegate {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logo.image = UIImage(imageLiteralResourceName: "logo")
        imageView.image = UIImage(imageLiteralResourceName: "stop")
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func recognize(_ sender: UIButton) {
        
        guard let mediaImage = Media(withImage: imageView.image!, forKey: "myfile") else { return }
        
        guard let url = URL(string: "http://161.35.118.47:8000/prediction/sign/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = Utils.generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Client-ID f65203f7020dddc", forHTTPHeaderField: "Authorization")
        
        let dataBody = Utils.createDataBody(/*withParameters: parameters,*/ media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
            
                DispatchQueue.main.async() {
                    // your UI update code
                    self.label.text = str
                }
            }
            }.resume()
    }
}

extension RoadsignViewController {

    func didSelect(image: UIImage?) {
        self.imageView.image = image
    }
}


