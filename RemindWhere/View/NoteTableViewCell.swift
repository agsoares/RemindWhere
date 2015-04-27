//
//  NoteTableViewCell.swift
//  RemindWhere
//
//  Created by Adriano Soares on 08/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
  
  @IBOutlet weak var noteTitle: UITextField!
  @IBOutlet weak var noteBody: UITextView!
  @IBOutlet weak var noteButton: UIButton!
  @IBOutlet weak var noteView: UIView!
  @IBOutlet weak var closeButton: UIButton!
  
  
  
  var note: PFObject!
  var fontColor = (UIApplication.sharedApplication().delegate as! AppDelegate).textColor
  
  override func awakeFromNib() {
    super.awakeFromNib()
    noteTitle.backgroundColor = UIColor.clearColor()
    noteBody.backgroundColor  = UIColor.clearColor()
    
    noteTitle.textColor   = fontColor
    noteBody.textColor    = fontColor
    closeButton.tintColor = fontColor.colorWithAlphaComponent(0.4)
    noteButton.tintColor  = fontColor
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func addLocation(sender: UIButton) {
    NSNotificationCenter.defaultCenter().postNotificationName("addLocationNotification", object: note)
  }
  
  @IBAction func deleteNote(sender: AnyObject) {
    NSNotificationCenter.defaultCenter().postNotificationName("removeNote", object: note)
  }
  
}
