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
    
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.

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
                print("User Logged In Successful----")
                guard let userID = Auth.auth().currentUser?.uid else
                {
                    return
                    
                }
                print("User ID---- ",userID)
                //TODO
                // Create a user object and store user_id, first name, last name, emailadress
                self.getUserByID(userID: userID)

                //
                
            }
          
        })
        
    }
    //Go to register screen
    @IBAction func registerUser(_ sender: Any) {
        performSegue(withIdentifier: "goToRegister", sender: self)
        
    }
    
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Invalid UserName/Password", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getUserByID(userID : String){
        let url = URL(string: "https://cs.okstate.edu/~cohutso/getUserByID.php/\(userID)")!
        
        let request = URLRequest(url: url)
        print("\(url)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                self.user = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.onDataLoaded()
                }
                
            } catch {
                print("\(error)")
            }
        }
        
        task.resume()
        
    }
    
    func onDataLoaded()
    {
        self.performSegue(withIdentifier: "goToHomeScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let homeView = segue.destination as? HomeViewController {
            homeView.userInfo = user
        }
    }
    
}


    
