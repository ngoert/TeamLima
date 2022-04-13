//
//  AddItemViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/5/22.
//

import UIKit
import PromiseKit
import AWSS3

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var myProgressLabel: UILabel!
    @IBOutlet weak var imageUploadProgressView: UIProgressView!
    
     
    var myProgress:Float = 0.0
    var prrogressLabelText:String = "0%"
    
    static var instance: AddItemViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddItemViewController.instance = self
        imageUploadProgressView.progress = myProgress
        myProgressLabel.text = prrogressLabelText
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
    
   
    
    @IBAction func uploadButtonTap(_ sender: Any) {
        DispatchQueue.main.async {
            var myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
           }
       

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
    
        myImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        myImageView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
        let request = uploadImage(image:  myImageView.image!)
        request.done { url in
            print("success",url)
            //TODO
            //Add the s3 url to user object which was created in successful login
            //Send the user object to database
            self.showErrorAlert(message: "Image Successfully uploaded in S3")
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            
        }.catch{ error in
            print("Error description")
            
        }
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
    }
    
    //Function to upload image in the S3 bucket
    func uploadImage(image:UIImage)->Promise<URL>{
        return Promise {resolver in
            let progressBlock: AWSS3TransferUtilityProgressBlock = {
                task,progress in
                DispatchQueue.main.async {
                    self.imageUploadProgressView.progress = Float(progress.fractionCompleted)
                    self.myProgressLabel.text = "\(floor(Float(progress.fractionCompleted)*100))"
                    print("image uploading :", progress.fractionCompleted)
                }
                
                
                
            }
            let uniqueName = ProcessInfo.processInfo.globallyUniqueString+".jpg"
            let transferUtility = AWSS3TransferUtility.default()
            let imageData = image.jpegData(compressionQuality: 0.1)
            let bucketName = "teamlimashareit"
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.progressBlock = progressBlock
            

            
            transferUtility.uploadData(imageData!, bucket: bucketName, key: uniqueName, contentType: "image/jpeg", expression: expression, completionHandler: {task, error in
                if let error = error{
                    resolver.reject(error)
                }else{
                    let imageUrl = URL(string:"https://\(bucketName).s3.amazonaws.com/\(uniqueName)")
                    resolver.fulfill(imageUrl!)
                }
                
                
            })
                
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Happy Sharing", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
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
