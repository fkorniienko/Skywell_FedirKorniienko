//
//  MainTableViewCell.swift
//  Skywell_FedirKorniienko
//
//  Created by Fedir Korniienko on 03.06.17.
//  Copyright © 2017 fedir. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var labelStaticPrice: UILabel!
    @IBOutlet weak var labelStaticCar: UILabel!
    @IBOutlet weak var imageViewAuto: UIImageView!
    @IBOutlet weak var labelAutoPrice: UILabel!
    @IBOutlet weak var labelAutoDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelStaticPrice.text = NSLocalizedString("price", comment: "")
        labelStaticCar.text = NSLocalizedString("car", comment: "")

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
