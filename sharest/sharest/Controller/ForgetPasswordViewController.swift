//
//  ForgetPasswordViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/12/22.
//

import UIKit
import FirebaseAuth

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var alertTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        alertTextLabel.text = "Password Link will sent to the registered email address!"
        alertTextLabel.adjustsFontSizeToFitWidth = true
        

        // Do any additional setup after loading the view.
    }
    
    // Add gradients
    override func viewWillAppear(_ animated: Bool) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [
            UIColor.systemOrange.cgColor,
            UIColor.systemPink.cgColor,
        ]
                                    
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    @IBAction func resetButtonPressed(_ sender: Any) {
         
        var button = sender as! UIButton
        
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { [self] error in
            // Your code here
            if error != nil{
                print(error?.localizedDescription)
                var errorMessage = error?.localizedDescription
                self.showErrorAlert(message: errorMessage!)
            }
            else{
                    alertTextLabel.textColor = .black
                    alertTextLabel.text! = "Password Reset Link sent to email!"

            }
            

        }
    }
    
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Invalid UserName", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
