//
//  EstadoUSATableViewCell.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 21/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//

import UIKit

class EstadoUSATableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbEstado: UILabel!
    @IBOutlet weak var lbTaxa: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(witch estado: State) {
        lbEstado.text = estado.title ?? ""
        lbTaxa.text = String(estado.tax)
    }
    
    

}
