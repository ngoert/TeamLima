//
//  InsightViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/6/22.
//

import UIKit

class InsightViewController: UIViewController {
    
    var userInfo = User()
    var userInsight = UserInsight()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInsights()
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
    

    func onInsightLoaded()
    {
        //TODO: do things with user insights
        print(userInsight.numPosts)
    }
    
    func getInsights() {
        let url = URL(string: "https://cs.okstate.edu/~cohutso/insightsForUser.php/\(userInfo.uuid)")!
            
            let request = URLRequest(url: url)
            print("\(url)")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                do {
                    self.userInsight = try JSONDecoder().decode(UserInsight.self, from: data)
                    DispatchQueue.main.async {
                        self.onInsightLoaded()
                    }
                    
                } catch {
                    print("\(error)")
                }
            }
            
            task.resume()
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
