//
//  GraphViewController.swift
//  Hotei
//
//  Created by Akshay  on 14/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit
import Charts
import CoreData


class GraphViewController: UIViewController {

    let def = UserDefaults.standard
    
    //Outlets needed
    
    
    @IBOutlet weak var barChartView: BarChartView!
    
    
    var history = [History]()
    
    var months: [String]!
    var dates: [Date] = []
    var emotions: [Double] = []
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch data and load into tableView.
        axisFormatDelegate = self
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let dateFrom = calendar.startOfDay(for: Date())
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dateFrom)
        components.day! += 1
        
        let dateTo = calendar.date(from: components)
        
        //let datePredicate = NSPredicate(format: "(%@ <= dateTime) AND (dateTime < %@)", argumentArray: [dateFrom, dateTo!])
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        
        //request.predicate = datePredicate
        
        
        do{
            //let queryResult = try context.execute(request) as! [History]
            let id = def.object(forKey: "userID") as! Int32
            var results = try context.fetch(request)
            results = results.filter({(result) -> Bool in
                return ((result as! History).userID == id)
                
            })
            
            for task in results as! [NSManagedObject]{
                dates.append(task.value(forKey: "dateTime")! as! Date)
                emotions.append(task.value(forKey: "rating")! as! Double)
                print("\(task.value(forKey: "activity")!)")
                print("\(task.value(forKey: "dateTime")!)")
            }
        }
        catch let error{
            print(error)
        }
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct" , "Nov" , "Dec"]
        //let unitsSold = [20.0, 4.0, 2.0, -13.0, 21.0, 16.0, -1.0, -12.0, 3.0, 0.0, 2.0, -1.0]
        
        //setChart(dataPoints: months, values: unitsSold)
        
        if(emotions.count > 0){
            setRatingGraph(dataPoints: dates, values: emotions)
            
        }
        barChartView.noDataText = "No Emotion Data Available"
        
        barChartView.animate(xAxisDuration: 0.1, yAxisDuration: 4.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setRatingGraph(dataPoints: [Date], values: [Double]){
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count{
            let timeIntervalForDate: TimeInterval = dataPoints[i].timeIntervalSince1970
            let dataEntry = BarChartDataEntry(x: Double(timeIntervalForDate), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Emotions (1: Happy, 0: Ok, -1: Sad)")
        let chartData = BarChartData(dataSet: chartDataSet)
        chartDataSet.colors = [UIColor.init(red: 87/255, green: 203/255, blue: 207/255, alpha: 1)]
        chartData.barWidth = 100
        barChartView.data = chartData
        
        let xaxis = barChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        barChartView.chartDescription?.text = "Emotion"
        barChartView.xAxis.labelPosition = .bottom
        
        
    }
    

}


extension GraphViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
