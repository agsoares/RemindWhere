//
//  NewNoteViewController.swift
//  RemindWhere
//
//  Created by Adriano Soares on 08/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import CoreData

class NewNoteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var dataManager: DataManager!
    
    var placeHolder = "Note Text"
    var noteColor = (UIApplication.sharedApplication().delegate as! AppDelegate).noteColors[0] as UIColor
    var placeHolderColor = UIColor.blackColor().colorWithAlphaComponent(0.25)
    var fontColor = (UIApplication.sharedApplication().delegate as! AppDelegate).textColor
  
    @IBOutlet weak var titleBar: UINavigationItem!
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteBody: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.dataManager = DataManager.sharedInstance
        }
      
      
      
        self.view.backgroundColor = noteColor
      
        noteTitle.backgroundColor = UIColor.clearColor()
        noteBody.backgroundColor  = UIColor.clearColor()
      
        noteTitle.textColor = fontColor
      
        titleBar.title = NSBundle.mainBundle().localizedStringForKey("New Note", value: "", table: nil)
      
        noteBody.text = placeHolder
        noteBody.textColor = placeHolderColor
        noteBody.delegate = self
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        noteBody.text = ""
        noteBody.textColor = fontColor
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if (noteBody.text.isEmpty) {
            noteBody.text = placeHolder
            noteBody.textColor = placeHolderColor
        }
        return true
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {
        var newNote = PFObject(className:"Note")
        newNote["title"] = noteTitle.text
        newNote["body"]  = noteBody.text
        newNote["color"] = noteColor.toString()
        
        var relation = newNote.relationForKey("user")
        relation.addObject(PFUser.currentUser()!)

        newNote.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.dataManager.noteList.addObject(newNote)
                self.performSegueWithIdentifier("returnFromNewNote", sender: nil)
            } else {
                // There was a problem, check error.description
            }
        }
    }

}
