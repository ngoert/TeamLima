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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
