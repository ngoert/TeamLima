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
        self.view.backgroundColor = UIColor(cgColor: CGColor(red: 235/255, green: 103/255, blue: 43/255, alpha: 1))

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [
            UIColor.systemOrange.cgColor,
            UIColor.systemPink.cgColor,
        ]
                                    
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    //Function to register user to database
    @IBAction func registerUserButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: userEmail.text!, password: userPassword.text!, completion: {(user, error) in
            if error != nil{
                print(error!)
            }
            else{
                print("User Registration Successful")
                guard let userID = Auth.auth().currentUser?.uid else
                {
                    return
                    
                }
                print("User ID---- ",userID)
                
            }
          
        })
        
        
    }
    
  

}
