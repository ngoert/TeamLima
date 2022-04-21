//
//  ProfileViewController.swift
//  sharest
//
//  This View Controller Informs the User of their own information
//  it includes a picture, their name, and some insights about their profiles activity.
//
//  Author: Cole Hutson
//  Email: cole.hutson@okstate.edu
//

import UIKit
import PromiseKit
import AWSS3

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
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
        
        downloadImage(url: userInfo.profileImageURL)
        profileImageView.image?.imageRendererFormat.opaque = false
    }
    
    func downloadImage(url:String){
        // Create URL
        
        if let url = URL(string: url)
        {
            print("Download started")
            let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                if let data = data {
                    DispatchQueue.main.async {
                        var profileImage = UIImage(data: data)
                        profileImage = self?.circleCrop(image: profileImage!)
                        self?.profileImageView.image = profileImage
                    }
                }
            }
            // Start Data Task
            dataTask.resume()
        }
    }
    
    @IBAction func updatePhotoPressed(_ sender: Any) {
        // Create an image Picker
        let myPickerController = UIImagePickerController()
        
        //setup image picker
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        //push the image picker onto view stack
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    // MARK: -- Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        let uploadedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage //the image picked by the user
        profileImageView.image = circleCrop(image: uploadedImage!) //crop to fit common aspect
        
        let request = uploadImage(image:  profileImageView.image!)
        request.done { url in
            print("success",url)
            DispatchQueue.main.async {
                self.updateUserPhoto(imageURL: url)
            }
        }.catch{ error in
            print("Error description")
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true) {}
    }
    
    //MARK: -- User Info Updates
    func updateUserPhoto(imageURL: URL)
    {
        userInfo.profileImageURL = "\(imageURL)"
        print("\(imageURL)")
        var data = Data()
        do {
            data = try JSONEncoder().encode(userInfo)
        } catch {
            print(error)
        }
        
        let url = URL(string: "https://cs.okstate.edu/~cohutso/updateUserPhoto.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
        }
        
        task.resume()
    }
    //MARK: -- Image Editing
    
    /*
        Crops the image to fit a circle
     */
    func circleCrop(image: UIImage) -> UIImage
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
        
        //since the image will be circular we need to enusre there is no background
        let imageRendererFormat = image.imageRendererFormat
        imageRendererFormat.opaque = false

      
        let circleCroppedImage = UIGraphicsImageRenderer(
            //starting the the square rect as abase
            size: cropRect.size,
            format: imageRendererFormat).image { context in
           
            // The drawRect is the cropRect starting at (0,0)
            let drawRect = CGRect(
                origin: .zero,
                size: cropRect.size
            )
         
            // creating an oval bezier curve in a square rect with result in a circle
            UIBezierPath(ovalIn: drawRect).addClip()

            // this rect is actually a squre with the circle clip applied
            let drawImageRect = CGRect(
                origin: CGPoint(
                    x: -xOffset,
                    y: -yOffset
                ),
                size: image.size
            )
                
            // Draws the sourceImage inside of the circular rect
            image.draw(in: drawImageRect)
        }
        
        return circleCroppedImage
        
    }
    
    // MARK: -- Image uploading
    //Function to upload image in the S3 bucket
    func uploadImage(image:UIImage)->Promise<URL>{
        return Promise {resolver in
            let progressBlock: AWSS3TransferUtilityProgressBlock = {
                task,progress in
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let insightController = segue.destination as? InsightViewController
        insightController?.userInfo = userInfo
    }
    

}
