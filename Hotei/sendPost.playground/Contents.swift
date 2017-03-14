//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)


//var str = "Hello, playground"
//
////////////
//let url2 = NSURL(string: "http://hoteiapi20170303100733.azurewebsites.net/GetAllData")
//
//let task2 = URLSession.shared.dataTask(with: url2! as URL) {(data, response, error) in
//    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
//}
//
//task2.resume()
//////////////////
//
//let json: [String: Any] = ["UserId": 0002,
//                           "Activity": "archery",
//                           "Rating": 1.0]
//
//let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//// create post request
//let url = URL(string: "http://hoteiapi20170303100733.azurewebsites.net/UserPerformActivity")!
//var request = URLRequest(url: url)
//request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
//request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
//request.httpMethod = "POST"
//
//// insert json data to the request
//request.httpBody = jsonData
//
//let task = URLSession.shared.dataTask(with: request) { data, response, error in
//    guard let data = data, error == nil else {
//        print(error?.localizedDescription ?? "No data")
//        return
//    }
//    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//    if let responseJSON = responseJSON as? [String: Any] {
//        print(responseJSON)
//        print("good")
//    }
//}
//
//task.resume()



let string1 = "Matt Smith"
extension String {
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
}
string1.asciiArray.reduce(0, +)
print(abs(string1.hash))

