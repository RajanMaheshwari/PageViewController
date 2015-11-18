//
//  SecondViewController.swift
//  PageViewWithSwipe
//
//  Created by Rajan Maheshwari on 02/09/15.
//  Copyright (c) 2015 rajanmaheshwari. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("second load")

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("second will appear")

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        print("second appear")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
