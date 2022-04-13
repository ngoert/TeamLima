//
//  QRCodeViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/6/22.
//

import UIKit

class QRCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< Updated upstream
=======
        
        let image = generateBarcode(from: "https://cs.okstate.edu/~fjaffri/qrcode.php/FJ/fjaffri@okstate.edu")
        qrImageView.image = image

>>>>>>> Stashed changes
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
