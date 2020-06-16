//
//  Media.swift
//  GitHub Networking Test
//
//  Created by Damian Roszczyk on 15/06/2020.
//  Copyright © 2020 Damian Roszczyk. All rights reserved.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "pic.jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
    
}
