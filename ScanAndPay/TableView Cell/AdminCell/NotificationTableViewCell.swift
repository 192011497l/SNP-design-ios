//
//  NotificationTableViewCell.swift
//  ScanAndPay
//
//  Created by SAIL on 08/01/24.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var tableImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
