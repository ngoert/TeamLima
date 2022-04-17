//
//  ProfileViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/6/22.
//

import UIKit

class ProfileViewController: UIViewController,UINavigationControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var userInfo = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "\(userInfo.firstName) \(userInfo.lastName)"
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
    
    @IBAction func updatePhotoPressed(_ sender: Any) {
        print("Upload your photo i guess")
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
