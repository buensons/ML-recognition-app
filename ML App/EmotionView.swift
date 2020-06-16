//
//  EmotionView.swift
//  GitHub Networking Test
//
//  Created by Damian Roszczyk on 13/06/2020.
//  Copyright © 2020 Damian Roszczyk. All rights reserved.
//

import Foundation
import UIKit

typealias Parameters = [String: String]

class EmotionViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logo.image = UIImage(imageLiteralResourceName: "logo")
        imageView.image = UIImage(imageLiteralResourceName: "chomsky")
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func recognize(_ sender: UIButton) {
        
        guard let mediaImage = Media(withImage: imageView.image!, forKey: "myfile") else { return }
        
        guard let url = URL(string: "http://161.35.118.47:8000/prediction/emotion/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = Utils.generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Client-ID f65203f7020dddc", forHTTPHeaderField: "Authorization")
        
        let dataBody = Utils.createDataBody(media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                let img = UIImage(data: data)
            
                DispatchQueue.main.async() {
                    self.imageView.image = img
                }
            }
        }.resume()
    }
}

extension EmotionViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.imageView.image = image
    }
}

