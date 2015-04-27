//
//  UserConfigTableViewController.swift
//  RemindWhere
//
//  Created by Adriano Soares on 09/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class UserConfigTableViewController: UITableViewController, FBSDKLoginButtonDelegate {
  
  @IBOutlet weak var notificationSwitch: UISwitch!
  @IBOutlet weak var distanceSlider: UISlider!
  @IBOutlet weak var distanceLabel: UILabel!
  
  var backgroundColor = (UIApplication.sharedApplication().delegate as! AppDelegate).backgroundColor
  var selectedTintColor = (UIApplication.sharedApplication().delegate as! AppDelegate).selectedTintColor
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = backgroundColor
    notificationSwitch.onTintColor = selectedTintColor
    distanceSlider.minimumTrackTintColor = selectedTintColor
    
    var loginButton = FBSDKLoginButton()
    loginButton.delegate = self
    loginButton.frame = CGRectMake(self.view.frame.width*0.2,
      (self.view.frame.height*0.75)-40,
      self.view.frame.width*0.6, 40)
    self.view.addSubview(loginButton)
    
  }
  
  
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

  }
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    PFUser.logOutInBackgroundWithBlock { (error) -> Void in
      self.performSegueWithIdentifier("logoutSegue", sender: nil)
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    notificationSwitch.on = NSUserDefaults.standardUserDefaults().valueForKey("SendNotification") as! Bool
    distanceSlider.value = NSUserDefaults.standardUserDefaults().valueForKey("AlertDistance") as! Float
    distanceLabel.text = String.localizedStringWithFormat("%.01f km", distanceSlider.value)
  }
  
  @IBAction func sliderValueChanged(sender: UISlider) {
    distanceLabel.text = String.localizedStringWithFormat("%.01f km", distanceSlider.value)
  }
  
  @IBAction func save(sender: AnyObject) {
    NSUserDefaults.standardUserDefaults().setValue(notificationSwitch.on, forKey: "SendNotification")
    NSUserDefaults.standardUserDefaults().setValue(distanceSlider.value, forKey: "AlertDistance")
    NSUserDefaults.standardUserDefaults().synchronize()
    performSegueWithIdentifier("returnFromConfig", sender: nil)
  }
  
}
