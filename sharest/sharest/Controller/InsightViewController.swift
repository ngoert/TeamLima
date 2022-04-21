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
    
    func onInsightLoaded()
    {
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
    
    func layoutPieChart()
    {
        // Build data set from insights pulled from CSX
        let insightDataSet = PieChartDataSet(entries: [
            PieChartDataEntry(value: Double(userInsight.numAsks), label: "Asks"),
            PieChartDataEntry(value: Double(userInsight.numPasses), label: "Passes")
        ])
        
        //stylizing the data set
        insightDataSet.colors = ChartColorTemplates.pastel()
        insightDataSet.label = ""
        
        pieChart.data = PieChartData(dataSet: insightDataSet);
        
        // additonal style information for the chart itself
        pieChart.holeRadiusPercent = 0.4
        
        pieChart.centerText = "Total: \(userInsight.numInteractions)"
        pieChart.centerTextRadiusPercent = 1.0
        pieChart.drawCenterTextEnabled = true

        pieChart.transparentCircleColor = NSUIColor.clear
        pieChart.isUserInteractionEnabled = false
        
        //Layout the pie chart within the view
        pieChart.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        pieChart.center = CGPoint(x: view.center.x, y: view.center.y - (view.frame.height / 4))
        
        view.addSubview(pieChart)
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
