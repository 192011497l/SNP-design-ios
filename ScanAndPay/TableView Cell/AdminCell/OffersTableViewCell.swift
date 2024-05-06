//
//  OffersTableViewCell.swift
//  ScanAndPay
//
//  Created by SAIL on 02/01/24.
//

import UIKit

class OffersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var offersLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
