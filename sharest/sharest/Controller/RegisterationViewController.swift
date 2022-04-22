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
    
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        registerButton.setImage(UIImage(named: "button_blank-2.png"), for: .normal)
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: userEmail.text!, password: userPassword.text!, completion: {(user, error) in
            if error != nil{
                self.registerButton.setImage(UIImage(named: "button_register.png"), for: .normal)
                self.activityIndicator.stopAnimating()
                
                print(error?.localizedDescription)
                var errorMessage = error?.localizedDescription
                self.showErrorAlert(message: errorMessage!)
            }
            else{
                print("User Registration Successful")
                guard let userID = Auth.auth().currentUser?.uid else
                {
                    return
                    
                }
                print("User ID---- ",userID)
                self.dismiss(animated: true, completion: nil)

                
                var newUser = User()
                newUser.uuid = (user?.user.uid)!
                newUser.emailAddress = self.userEmail.text!
                newUser.firstName = self.firstNameLabel.text!
                newUser.lastName = self.lastNameLabel.text!
                
                
                do{
                    let jsonData = try JSONEncoder().encode(newUser)
                    DispatchQueue.main.async {
                        self.postUserData(data: jsonData)
                    }
                }
                catch {
                    print("\(error)")
                }
            }
          
        })
    }
    
    func postUserData(data: Data) {
        let url = URL(string: "https://cs.okstate.edu/~cohutso/postUser.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        task.resume()
    }
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
