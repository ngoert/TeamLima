//
//  AddItemViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/5/22.
//

import UIKit
import PromiseKit
import AWSS3

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var itemNameLabel: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageUploadProgressView: UIProgressView!
    
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var userInfo = User()
    var hasUploadedPhoto = false
    
    static var instance: AddItemViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self;
        AddItemViewController.instance = self
        imageUploadProgressView.isHidden = true
        
        //update placeholder text of description box
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = UIColor.placeholderText
        
        descriptionTextView.layer.cornerRadius = 5.0
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
    
    @IBAction func didTapAddImage(_ sender: UITapGestureRecognizer){
        let myPickerController = UIImagePickerController()
        
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }
       
    @IBAction func uploadButtonTap(_ sender: Any) {
        uploadButton.setImage(UIImage(named: "button_blank_upload.png"), for: .normal)
        activityIndicator.startAnimating()
        
        if !hasUploadedPhoto
        {
            self.uploadButton.setImage(UIImage(named: "button_upload.png"), for: .normal)
            self.activityIndicator.stopAnimating()
            
            self.highlightMissingField()
            
        }
        else if itemNameLabel.text!.isEmpty
        {
            self.uploadButton.setImage(UIImage(named: "button_upload.png"), for: .normal)
            self.activityIndicator.stopAnimating()
            
            let notUploadedAlert = UIAlertController(title: "Item has no name", message: "Please give your item a name.", preferredStyle: .alert)
            notUploadedAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default Action"), style: .default, handler: {_ in }))
            self.present(notUploadedAlert, animated: true)
        }
        else if descriptionTextView.textColor == UIColor.placeholderText
        {
            self.uploadButton.setImage(UIImage(named: "button_upload.png"), for: .normal)
            self.activityIndicator.stopAnimating()
            
            let notUploadedAlert = UIAlertController(title: "Item has no description", message: "Please give your item a description.", preferredStyle: .alert)
            notUploadedAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default Action"), style: .default, handler: {_ in }))
            self.present(notUploadedAlert, animated: true)
        }
        else
        {
            let request = uploadImage(image:  myImageView.image!)
            request.done { url in
                print("success",url)
                DispatchQueue.main.async {
                    self.uploadItemListing(imageURL: url)
                }
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
                
            }.catch{ error in
                print("Error description")
                
            }
        }
        
    }
    
    func highlightMissingField()
    {
        myImageView.layer.borderColor = CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        myImageView.layer.borderWidth = 5
        
    }
    /*
     In the image picker controller the user can pick the image they want to use as the lisitng's visual
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        let uploadedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage //the image picked by the user
        myImageView.image = squareCrop(image: uploadedImage!) //crop to fit common aspect
        myImageView.backgroundColor = UIColor.clear
        
        hasUploadedPhoto = true;
        self.dismiss(animated: true, completion: nil)
        addImageLabel.isHidden = true
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true) {}
    }
    
    //Function to upload image in the S3 bucket
    func uploadImage(image:UIImage)->Promise<URL>{
        return Promise {resolver in
            let progressBlock: AWSS3TransferUtilityProgressBlock = {
                task,progress in
                DispatchQueue.main.async {
                    self.imageUploadProgressView.isHidden = false
                    self.imageUploadProgressView.progress = Float(progress.fractionCompleted)
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
    
    func uploadItemListing(imageURL: URL)
    {
        let listing = Listing()
        listing.itemName = itemNameLabel.text!
        listing.description = descriptionTextView.text!
        listing.uuid = userInfo.uuid
        listing.imageURL = "\(imageURL)";
        
        var data = Data()
        do {
            data = try JSONEncoder().encode(listing)
        } catch {
            print(error)
        }
        
        let url = URL(string: "https://cs.okstate.edu/~cohutso/postListing.php")!
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
    
    /*
        Crops the image to fit a unifrom square aspect ratio of 1:1
     */
    func squareCrop(image: UIImage) -> UIImage
    {
        //get shortest side for square crop
        let sideLength = min(
            image.size.width,
            image.size.height
        )
        
        //determine the offset of the center of the image
        let size = image.size
        let xOffset = (size.width - sideLength) / 2.0
        let yOffset = (size.height - sideLength) / 2.0
        
        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: sideLength,
            height: sideLength
        ).integral
        
        let cgImage = image.cgImage!
        let croppedImage = cgImage.cropping(to: cropRect)!
        
        return UIImage(cgImage: croppedImage, scale: image.imageRendererFormat.scale, orientation: image.imageOrientation)
    }
    
    //MARK: - Text View Delegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.placeholderText
        }
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
