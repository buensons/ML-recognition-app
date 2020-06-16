//
//  LoginViewController.swift
//  To-Do App
//
//  Created by Damian Roszczyk on 27/04/2019.
//  Copyright © 2019 Damian Roszczyk. All rights reserved.
//

import UIKit
import Foundation
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = UIImage(imageLiteralResourceName: "logo")
    }
    
    @IBAction func handleFaceID(_ sender: Any) {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Provide Authentication in order to continue") { (wasSuccessful, error) in
                if wasSuccessful {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "login", sender: self)
                    }
                } else {
                    // alert
                    print("Incorrect credentials")
                }
            }
        } else {
            // alert
            print("FaceID/TouchID is not enabled on your device. Go to settings.")
        }
    }
}
