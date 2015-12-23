//
//  TaskItemCell.swift
//  Aims
//
//  Created by Yilun Liu on 12/22/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import UIKit

class TaskItemCell: UITableViewCell {
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.checkButton.setImage(UIImage(named: "checkbox_unchecked"), forState: .Normal)
        self.checkButton.setImage(UIImage(named: "checkbox_checked"), forState: .Selected)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setChecked(checked:Bool){
        self.titleLabel.enabled = !checked
        self.timeLabel.enabled = !checked
        self.checkButton.selected = checked
    }
    

//    @IBAction func checkButtonPressed(sender: AnyObject) {
//        let checked = !self.checkButton.selected
//        self.titleLabel.enabled = !checked
//        self.timeLabel.enabled = !checked
//        self.checkButton.selected = checked
//    }
}
