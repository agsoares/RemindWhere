//
//  NewNoteViewController.swift
//  RemindWhere
//
//  Created by Adriano Soares on 08/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import CoreData

class NewNoteViewController: UIViewController {

    var noteManager: NoteManager = NoteManager.sharedInstance
    var managedObjectContext: NSManagedObjectContext!
    
    // Create the error pointer
    var err: NSErrorPointer = nil
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteBody: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {
        var newNote: Note = NSEntityDescription.insertNewObjectForEntityForName("Note",
            inManagedObjectContext: managedObjectContext) as! Note
        
        newNote.title = noteTitle.text
        newNote.body = noteBody.text
        newNote.longitude = 0
        newNote.latitude = 0
        managedObjectContext.save(err)
        if(err == nil) {
            noteManager.noteList.addObject(newNote)
        }
        performSegueWithIdentifier("returnFromNewNote", sender: nil)
        
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
