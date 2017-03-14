//
//  BarViewController.swift
//  Hotei
//
//  Created by Akshay  on 13/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit
import Charts
import CoreData

class BarViewController: UIViewController , UINavigationBarDelegate{

    let def = UserDefaults.standard
    @IBOutlet weak var navBar: UINavigationBar!

    
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var history = [History]()
    
    var months: [String]!
    var dates: [Date] = []
    var emotions: [Double] = []
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        axisFormatDelegate = self
        
        //try? history = context.fetch(History.fetchRequest())
        
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let dateFrom = calendar.startOfDay(for: Date())
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dateFrom)
        components.day! += 1
        
        let dateTo = calendar.date(from: components)
        
        let datePredicate = NSPredicate(format: "(%@ <= dateTime) AND (dateTime < %@)", argumentArray: [dateFrom, dateTo!])
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        
        request.predicate = datePredicate
        
        
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
        let unitsSold2 = [20.0, 4.0, 2.0, 15.0]
    
        //setChart(dataPoints: months, values: unitsSold)
        setRatingGraph(dataPoints: dates, values: emotions)
        setHRGraph(dataPoints: dates, values: unitsSold2)
        barChartView.animate(xAxisDuration: 0.1, yAxisDuration: 4.0)
        
        lineChartView.animate(xAxisDuration: 1, yAxisDuration: 1)
        
        
        // Do any additional setup after loading the view.
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
        chartData.barWidth = 2000
        barChartView.data = chartData
        
        let xaxis = barChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        barChartView.chartDescription?.text = "Emotion"
        barChartView.xAxis.labelPosition = .bottom
        
    }
    
    func setHRGraph(dataPoints: [Date], values: [Double]){
        var dataEntries: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0..<dataPoints.count{
            let timeIntervalForDate: TimeInterval = dataPoints[i].timeIntervalSince1970
            let dataEntry = ChartDataEntry(x: Double(timeIntervalForDate), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Heart Rate")
        let chartData = LineChartData(dataSet: chartDataSet)
        lineChartView.data = chartData
        
        let xaxis = lineChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        
    }
    
    
    func setChart(dataPoints: [String], values: [Double]){
        
        lineChartView.noDataText = "No Heart Rate Available"
        lineChartView.noDataTextColor = UIColor.red
        barChartView.noDataText = "You Need to Provide Data for the Chart"
        barChartView.noDataTextColor = UIColor.red
        
        var dataEntries: [BarChartDataEntry] = []
        var yVals: [ChartDataEntry] = [ChartDataEntry]()
        for i in 0..<dataPoints.count{
            yVals.append(ChartDataEntry(x: Double(i), y: values[i]))
        }
        
        for i in 0..<dataPoints.count{
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            
            dataEntries.append(dataEntry)
        }
        
        
        let lineChartDataSet = LineChartDataSet(values: yVals, label: "Unit Set")
        
        lineChartDataSet.setColor(UIColor.red)
        let lineData = LineChartData(dataSet: lineChartDataSet)
        
        lineChartView.data = lineData
        
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        
        //chartDataSet.colors = [UIColor.init(red: 87/255, green: 203/255, blue: 207/255, alpha: 1)]
        chartDataSet.colors = ChartColorTemplates.liberty()
        let chartData = BarChartData(dataSet: chartDataSet)
        
        barChartView.data = chartData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        barChartView.xAxis.axisLineColor = UIColor.white
        //barChartView.xAxis.labelTextColor = UIColor.white
        barChartView.leftAxis.axisLineColor = UIColor.white
    
        barChartView.chartDescription?.text = "Emotion"
        barChartView.gridBackgroundColor = UIColor.black
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BarViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
