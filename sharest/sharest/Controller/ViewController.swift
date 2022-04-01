//
//  ViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/1/22.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func registerUser(_ sender: Any) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
}

