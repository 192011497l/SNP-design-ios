//
//  HistoryDetailsTableViewCell.swift
//  ScanAndPay
//
//  Created by SAIL on 04/01/24.
//

import UIKit

class HistoryDetailsTableViewCell: UITableViewCell {

  
   
    
    @IBOutlet weak var sNoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var QtyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
