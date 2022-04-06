//
//  HomeViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/2/22.
//

import UIKit
import FirebaseAuth
import SideMenu

class HomeViewController: UIViewController {
    
    var menu: SideMenuNavigationController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        //navigationItem.hidesBackButton = true
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        

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
    @IBAction func didTapMenuButton(){
        present(menu!,animated: true)
        
    }
  

}

class MenuListController: UITableViewController{
    var items = ["Profile","Add Items", "Insights", "QR Code", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.backgroundColor = .orange
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:  "cell" )
    }
    func logoutUser() {
        // call from any screen
        
        do { try
            Auth.auth().signOut()
            print("User logged out")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(identifier: "loginViewController")
                    
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.modalTransitionStyle = .crossDissolve
                    
            present(loginVC, animated: true, completion: nil)
        }
        catch { print("already logged out") }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count

    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        //cell.backgroundColor = .orange
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if items[indexPath.row] == "Profile"{
          
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let profileViewController = storyBoard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
            show(profileViewController, sender: self)
        }
        if items[indexPath.row] == "Add Items"{
          
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let addItemViewController = storyBoard.instantiateViewController(withIdentifier: "addItemViewController") as! AddItemViewController
            show(addItemViewController, sender: self)
        }
        
        if items[indexPath.row] == "Insights"{
          
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let insightViewController = storyBoard.instantiateViewController(withIdentifier: "insightViewController") as! InsightViewController
            show(insightViewController, sender: self)
        }
        if items[indexPath.row] == "QR Code"{
          
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let qrCodeViewController = storyBoard.instantiateViewController(withIdentifier: "qRCodeViewController") as! QRCodeViewController
            show(qrCodeViewController, sender: self)
        }
        
        if items[indexPath.row] == "Logout"{
          
            logoutUser()
        }
    }
    
 
}
