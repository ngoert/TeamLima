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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //Function to register user to database
    @IBAction func registerUserButton(_ sender: Any) {
        navigationController?.navigationBar.isHidden = true
        
        Auth.auth().createUser(withEmail: userEmail.text!, password: userPassword.text!, completion: {(user, error) in
            if error != nil{
                print(error!)
            }
            else{
                print("User Registration Successful")
                print(user)
                
                let newUser = User()
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
  

}
