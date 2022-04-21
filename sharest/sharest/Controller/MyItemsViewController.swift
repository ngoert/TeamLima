//
//  MyItemsViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/6/22.
//

import UIKit
import Photos
import PhotosUI


class MyCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    var listing = Listing();
    
    func setListing(listing: Listing)
    {
        self.listing = listing
        downloadAndSetImage(url: listing.imageURL)
    }
    
    func downloadAndSetImage(url:String) {
        // Create URL
        let url = URL(string: url)!
        print("Download started")
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
               if let data = data {
                   DispatchQueue.main.async { [self] in
                       // Create Image and Update Image View
                       print("Downloading image from url.......")
                       self?.itemImageView.image = UIImage(data: data)
                   }
               }
        }

        // Start Data Task
        dataTask.resume()
    }
}

class MyItemsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var itemCollectionView: UICollectionView!
    var userInfo = User()
    var listings : [Listing] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        
        getLisitingsForUser()
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
    
    //MARK: -- CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MyCell else { fatalError() }
        cell.setListing(listing: listings[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(listings.count > 0)
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let itemDetailController = storyBoard.instantiateViewController(withIdentifier: "ItemDetailController") as! ItemDetailViewController

            if let cell = collectionView.cellForItem(at: indexPath) as? MyCell {
                itemDetailController.listingImage = cell.itemImageView.image!
                itemDetailController.listing = cell.listing
                present(itemDetailController, animated: true, completion: nil)
            }
        }


    }
    // MARK: --Data Retreival
    
    func getLisitingsForUser() {
        let url = URL(string: "https://cs.okstate.edu/~cohutso/getListingsForUser.php/\(userInfo.uuid)")!
        
        let request = URLRequest(url: url)
        print("\(url)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                self.listings = try JSONDecoder().decode([Listing].self, from: data)
                DispatchQueue.main.async {
                    self.onListingsLoaded()
                }
                
            } catch {
                print("\(error)")
            }
        }
        
        task.resume()
    }
    
    func onListingsLoaded() {
        itemCollectionView.reloadData()
    }
}
