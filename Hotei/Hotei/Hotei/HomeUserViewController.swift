//
//  HomeUserViewController.swift
//  Hotei
//
//  Created by Sangeetha on 13/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class HomeUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actbrn(_ sender: Any) {
        
        self.performSegue(withIdentifier: "activityuser", sender: sender)
        
    }

    @IBAction func emotionuser(_ sender: Any) {
        self.performSegue(withIdentifier: "emouser", sender: sender)

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
