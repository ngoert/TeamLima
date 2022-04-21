//
//  ItemDetailViewController.swift
//  sharest
//
//  Created by Cole Hutson on 4/21/22.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    var listing = Listing();
    var listingImage = UIImage();
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemImageView.image = listingImage;
        itemNameLabel.text = listing.itemName
        itemDescriptionLabel.text = listing.description
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
