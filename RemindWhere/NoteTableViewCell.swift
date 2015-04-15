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
    var note: Note!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addLocation(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("addLocationNotification", object: note)
    }


}
