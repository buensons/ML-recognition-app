//
//  Utilities.swift
//  ML App
//
//  Created by Damian Roszczyk on 16/06/2020.
//  Copyright © 2020 Damian Roszczyk. All rights reserved.
//

import Foundation

class Utils {
    
    static func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    static func createDataBody(media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
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
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
