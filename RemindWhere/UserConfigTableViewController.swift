//
//  UserConfigTableViewController.swift
//  RemindWhere
//
//  Created by Adriano Soares on 09/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit

class UserConfigTableViewController: UITableViewController {

    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        notificationSwitch.on = NSUserDefaults.standardUserDefaults().valueForKey("SendNotification") as! Bool
        distanceSlider.value = NSUserDefaults.standardUserDefaults().valueForKey("AlertDistance") as! Float
        distanceLabel.text = distanceSlider.value.description + " km"
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        distanceLabel.text = sender.value.description + " km"
    }
    
    @IBAction func save(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setValue(notificationSwitch.on, forKey: "SendNotification")
        NSUserDefaults.standardUserDefaults().setValue(distanceSlider.value, forKey: "AlertDistance")
        NSUserDefaults.standardUserDefaults().synchronize()
        performSegueWithIdentifier("returnFromConfig", sender: nil)
    }

}
