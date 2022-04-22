//
//  QRCodeViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/6/22.
//

import UIKit
import MessageUI


class QRCodeViewController: UIViewController, MFMailComposeViewControllerDelegate {
    var firstName = ""
    var emailAddress = ""
    let mail = MFMailComposeViewController()
  

    @IBOutlet weak var qrImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mail.mailComposeDelegate = self
        let image = generateBarcode(from: "https://cs.okstate.edu/~fjaffri/qrcode.php/\(firstName)/\(emailAddress)")
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
    
    @IBAction func shareIt(_ sender: UIButton) {
        //generate interaction data for an ask
        
        if (MFMailComposeViewController.canSendMail()){
        
        mail.setToRecipients(["jeffaiz72@gmail.com"])
        mail.setSubject("QR Core")
            mail.setMessageBody("Scan below code to contact", isHTML: false)
        let imageData: NSData = qrImageView.image!.pngData()!
        as NSData
        mail.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "imageName.png")
        self.present(mail, animated: true, completion: nil)
        }
        else{
            print("Internet not working/Email will not work in simulator")
            //loadNextImage()
        }
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result:          MFMailComposeResult, error: Error?) {
          if let _ = error {
             self.dismiss(animated: true, completion: nil)
          }
          switch result {
             case .cancelled:
             print("Cancelled")
            mail.dismiss(animated: true, completion: nil)

             break
             case .sent:
             print("Mail sent successfully")
            mail.dismiss(animated: true, completion: nil)

             break
             case .failed:
             print("Sending mail failed")
            mail.dismiss(animated: true, completion: nil)

             break
             default:
             break
          }
          controller.dismiss(animated: true, completion: nil)
       }
}

