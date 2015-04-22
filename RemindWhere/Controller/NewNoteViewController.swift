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
    
    var placeHolder = "Placeholder Text"
    
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteBody: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.dataManager = DataManager.sharedInstance
        }
        
        noteBody.text = placeHolder
        noteBody.textColor = UIColor.blackColor().colorWithAlphaComponent(0.25)
        noteBody.delegate = self
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        noteBody.text = ""
        noteBody.textColor = UIColor.blackColor()
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if (noteBody.text.isEmpty) {
            noteBody.text = placeHolder
            noteBody.textColor = UIColor.blackColor().colorWithAlphaComponent(0.25)
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        if (noteBody.text.isEmpty) {
            noteBody.text = placeHolder
            noteBody.textColor = UIColor.blackColor().colorWithAlphaComponent(0.25)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {
        var newNote = PFObject(className:"Note")
        newNote["title"] = noteTitle.text
        newNote["body"] = noteBody.text
        
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
