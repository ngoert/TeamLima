//
//  QRCodeViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/6/22.
//

import UIKit
import MessageUI


class QRCodeViewController: UIViewController {

    @IBOutlet weak var qrImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(cgColor: CGColor(red: 235/255, green: 103/255, blue: 43/255, alpha: 1))
        let image = generateBarcode(from: "https://cs.okstate.edu/~fjaffri/qrcode.php/FJ/fjaffri@okstate.edu")
        qrImageView.image = image

        // Do any additional setup after loading the view.
    }
    

    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}

