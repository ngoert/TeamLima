//
//  HomeViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/2/22.
//

import UIKit
import FirebaseAuth
import SideMenu
import PromiseKit
import MessageUI

class HomeViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    
    var menu: SideMenuNavigationController?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var imageDescription: UILabel!
    let mail = MFMailComposeViewController()

    var userInfo : User = User()
    var listings : [Listing] = []
    var currentListing = 0;
    var i = 1

    
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mySpinner.hidesWhenStopped = true
        mail.mailComposeDelegate = self;
        //Add border to imageview
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true

        getLisitings();
        
        let menuController = MenuListController()
        menu = SideMenuNavigationController(rootViewController: menuController)
        menu?.leftSide = true
        menuController.userInfo = userInfo
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    func getLisitings()
    {
        let url = URL(string: "https://cs.okstate.edu/~cohutso/getAllListings.php/\(userInfo.uuid)")!
        
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
                    self.onDataLoaded()
                }
                
            } catch {
                print("\(error)")
            }
        }
        
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [
            UIColor.systemOrange.cgColor,
            UIColor.systemPink.cgColor,
        ]
                                    
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Simulator do not support email functionality", message: "Please connect Iphone to send emails", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func sendEmailTapped(_ sender: UIButton) {
        //generate interaction data for an ask
        let interaction = Interaction()
        interaction.didPass = false;
        interaction.interactorID = userInfo.uuid
        interaction.ownerID = listings[currentListing].uuid
        interaction.listingID = Int(listings[currentListing].listingID)!

        postInteraction(interaction);
        
        if (MFMailComposeViewController.canSendMail()){
        
        mail.setToRecipients([userInfo.emailAddress])
        mail.setSubject(listings[currentListing].itemName)
            mail.setMessageBody("Hi my name is \(userInfo.firstName) \(userInfo.lastName)\n I am intersted in the item", isHTML: false)
        let imageData: NSData = imageView.image!.pngData()!
        as NSData
        mail.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "imageName.png")
        self.present(mail, animated: true, completion: nil)
        }
        else{
            showErrorAlert()
            print("Email will not work in simulator")
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
    
    func onDataLoaded() {
        let listingURL = listings[currentListing].imageURL
        downloadImage(url:listingURL);
        mySpinner.stopAnimating()
    }
    
    func downloadImage(url:String){
        // Create URL
        mySpinner.startAnimating()

        let url = URL(string: url)!
        print("Download started")
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
               if let data = data {
                   DispatchQueue.main.async { [self] in
                       // Create Image and Update Image View
                       print("Downloading image from url.......")
                       self?.mySpinner.stopAnimating()
                       UIView.transition(with: self!.itemView, duration: 0.25, options: .transitionFlipFromLeft, animations: {}, completion: nil)
                       self?.imageView.image = UIImage(data: data)
                       self?.itemNameLabel.text = self?.listings[self!.currentListing].itemName
                       self?.imageDescription.text = self?.listings[self!.currentListing].description

                       
                   }
               }
           }

           // Start Data Task
           dataTask.resume()
    }

    @IBAction func didPressNext(_ sender: Any) {
        
        //generate interaction data for a pass
        let interaction = Interaction()
        interaction.didPass = true;
        interaction.interactorID = userInfo.uuid
        interaction.ownerID = listings[currentListing].uuid
        interaction.listingID = Int(listings[currentListing].listingID)!

        postInteraction(interaction);
        
        loadNextImage()
        
    }
    
    func loadNextImage()
    {
        currentListing += 1
        
        if(currentListing < listings.count)
        {
            onDataLoaded()
        }
        else
        {
            currentListing = 0
            onDataLoaded()
        }
    }
    
    @IBAction func didTapMenuButton(){
        present(menu!,animated: true)
        
    }
  
    func postInteraction(_ interaction: Interaction)
    {
        var data = Data()
        do {
            data = try JSONEncoder().encode(interaction)
        } catch {
            print(error)
        }
        
        let url = URL(string: "https://cs.okstate.edu/~cohutso/postInteraction.php")!
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

}

// MARK: --Side Menu
class MenuListController: UITableViewController{
    var items = ["Profile","Add Items", "QR Code","My Items", "Logout"]
    var userInfo = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(cgColor: CGColor(red: 200/255, green: 80/255, blue: 30/255, alpha: 1))
       
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:  "cell" )
    }
    func logoutUser() {
        // call from any screen
        do { try
            Auth.auth().signOut()
            print("User logged out")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let profileViewController = storyBoard.instantiateViewController(withIdentifier: "loginViewController") as! ViewController
            show(profileViewController, sender: self)
        }
        catch { print("already logged out") }
    }
    
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
  
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 50, y: 50, width:600, height: 600))
        let userImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 200, height: 200))
        userImageView.image = UIImage(named: "logo")
        userImageView.layer.cornerRadius = userImageView.bounds.size.width
        footer.addSubview(userImageView )
        return footer
    }
 
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        //cell.backgroundColor = UIColor(cgColor: CGColor(red: 235/255, green: 103/255, blue: 43/255, alpha: 1))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if items[indexPath.row] == "Profile"{
          
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let profileViewController = storyBoard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
            profileViewController.userInfo = userInfo
            show(profileViewController, sender: self)
        }
        if items[indexPath.row] == "Add Items"{
          
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let addItemViewController = storyBoard.instantiateViewController(withIdentifier: "addItemViewController") as! AddItemViewController
            addItemViewController.userInfo = userInfo
            show(addItemViewController, sender: self)
        }
        if items[indexPath.row] == "QR Code"{
          
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let qrCodeViewController = storyBoard.instantiateViewController(withIdentifier: "qRCodeViewController") as! QRCodeViewController
            qrCodeViewController.firstName = userInfo.firstName
            qrCodeViewController.emailAddress = userInfo.emailAddress
            show(qrCodeViewController, sender: self)
        }
        if items[indexPath.row] == "My Items"{
          
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let myItemsViewController = storyBoard.instantiateViewController(withIdentifier: "myItemsViewController") as! MyItemsViewController
            show(myItemsViewController, sender: self)
            myItemsViewController.userInfo = userInfo
        }
        if items[indexPath.row] == "Logout"{
          
            logoutUser()
        }
    }
    
 
}

