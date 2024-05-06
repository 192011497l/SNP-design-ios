//
//  HistoryTableViewCell.swift
//  ScanAndPay
//
//  Created by SAIL on 04/01/24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentIDLabel: UILabel!
    @IBOutlet weak var paymentDateLabel: UILabel!
    @IBOutlet weak var billStatusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
