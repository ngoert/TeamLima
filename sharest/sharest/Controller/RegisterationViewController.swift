//
//  RegisterationViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/1/22.
//

import UIKit
import FirebaseAuth
class RegisterationViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerUserButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: userEmail.text!, password: userPassword.text!, completion: {(user, error) in
            if error != nil{
                print(error!)
            }
            else{
                print("User Registration Successful")
                print(user)
                
            }
          
        })
        
        
    }
    
  

}
