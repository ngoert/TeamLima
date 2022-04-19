//
//  InsightViewController.swift
//  sharest
//
//  Created by Faisal Jaffri on 4/6/22.
//

import UIKit
import Charts

class InsightViewController: UIViewController, ChartViewDelegate {
    
    var userInfo = User()
    var userInsight = UserInsight()
    
    var pieChart = PieChartView()
    @IBOutlet weak var insightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInsights()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    func layoutPieChart()
    {
        pieChart.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        pieChart.center = view.center
        
        view.addSubview(pieChart)
        
        let insightDataSet = PieChartDataSet(entries: [
            PieChartDataEntry(value: Double(userInsight.numAsks), label: "Asks"),
            PieChartDataEntry(value: Double(userInsight.numPasses), label: "Passes")
        ])
        
        insightDataSet.label = "Item Interactions"
        insightDataSet.colors = ChartColorTemplates.pastel()
        let interactionData = PieChartData(dataSet: insightDataSet)
        pieChart.data = interactionData;
        pieChart.isUserInteractionEnabled = false
    }
    
    func onInsightLoaded()
    {
        //TODO: do things with user insights
        layoutPieChart()
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
