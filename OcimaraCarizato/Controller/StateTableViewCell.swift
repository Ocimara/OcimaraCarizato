//
//  StateTableViewCell.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 29/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//

import UIKit

class StateTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTax: UILabel!
    @IBOutlet weak var lbState: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(witch state: State) {
        lbState.text = state.title ?? ""
        lbTax.text = String(state.tax)
        
        
    }

}
