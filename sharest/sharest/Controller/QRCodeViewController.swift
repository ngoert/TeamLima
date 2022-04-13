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
        
        let image = generateBarcode(from: "https://cs.okstate.edu/~fjaffri/qrcode.php/FJ/fjaffri@okstate.edu")
        qrImageView.image = image
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

