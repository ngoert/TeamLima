//
//  ViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/1/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    

    @IBOutlet weak var loginUserText: UITextField!
    
    @IBOutlet weak var passwordUserText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
       // self.view.backgroundColor = UIColor(cgColor: CGColor(red: 235/255, green: 103/255, blue: 43/255, alpha: 1))

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
    //Function to sign in user to database
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: loginUserText.text!, password: passwordUserText.text!, completion: {(user, error) in
            if error != nil{
                print("Error while Login---------------")
                print(error?.localizedDescription)
                var errorMessage = error?.localizedDescription
                self.showErrorAlert(message: errorMessage!)
                
            }
            else{
                print("User Logged Successful----")
                guard let userID = Auth.auth().currentUser?.uid else
                {
                    return
                    
                }
                print("User ID---- ",userID)
                //TODO
                // Create a user object and store user_id, first name, last name, emailadress

                self.performSegue(withIdentifier: "goToHomeScreen", sender: self)
                
            }
          
        })
        
    }
    //Go to register screen
    @IBAction func registerUser(_ sender: Any) {
        performSegue(withIdentifier: "goToRegister", sender: self)
        
    }
    
    
    @IBAction func forgetPassword(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
         let destVC = storyboard.instantiateViewController(withIdentifier: "forgetPasswordVC") as! ForgetPasswordViewController

        destVC.modalPresentationStyle = UIModalPresentationStyle.popover
        destVC.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal

         self.present(destVC, animated: true, completion: nil)
    }
    
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Invalid UserName/Password", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}


    
extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
