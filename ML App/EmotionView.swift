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
        
        let parameters = ["name": "MyTestFile123321",
        "description": "My tutorial test file for MPFD uploads"]
        
        guard let mediaImage = Media(withImage: imageView.image!, forKey: "myfile") else { return }
        
        guard let url = URL(string: "http://161.35.118.47:8000/prediction/emotion/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Client-ID f65203f7020dddc", forHTTPHeaderField: "Authorization")
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                let img = UIImage(data: data)
            
                DispatchQueue.main.async() {
                    // your UI update code
//                    self.label.text = str
                    self.imageView.image = img
                }
                
                //                do {
                //                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                //                    let str = String(decoding: data, as: UTF8.self)
                //                    print(str)
            
//                } catch {
//                    print(error)
//                }
            }
            }.resume()
    }
}

func generateBoundary() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}

func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
    
    let lineBreak = "\r\n"
    var body = Data()
    
    if let parameters = params {
        for (key, value) in parameters {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value + lineBreak)")
        }
    }
    
    if let media = media {
        for photo in media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
            body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
            body.append(photo.data)
            body.append(lineBreak)
        }
    }
    
    body.append("--\(boundary)--\(lineBreak)")
    
    return body
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension EmotionViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.imageView.image = image
    }
}

