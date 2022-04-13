//
//  NetworkManager.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/5/22.
//

import UIKit
import PromiseKit
import AWSS3
class NetworkManager{
    static let api = NetworkManager()
    private init(){}

    func uploadImage(image:UIImage)->Promise<URL>{
        return Promise {resolver in
            let progressBlock: AWSS3TransferUtilityProgressBlock = {
                task,progress in
                print("image uploading :", progress.fractionCompleted)
                
                
            }
            let uniqueName = ProcessInfo.processInfo.globallyUniqueString+".jpg"
            let transferUtility = AWSS3TransferUtility.default()
            let imageData = image.jpegData(compressionQuality: 1)
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
    
    
}
