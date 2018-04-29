//
//  ProdutoTableViewCell.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 19/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//

import UIKit

class ProdutoTableViewCell: UITableViewCell {

    @IBOutlet weak var ivProduto: UIImageView!
    @IBOutlet weak var lbProduto: UILabel!
    @IBOutlet weak var lbPrecoDolar: UILabel!
        var calc = Calculator.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepare(witch produto: Product) {
        lbProduto.text = produto.title ?? ""
        lbPrecoDolar.text = calc.getFormattedValue(of: produto.vlProduct, withCurrency: "U$ ")
        if let image = produto.imgProduct as? UIImage {
            ivProduto.image = image
        }
        else {
            ivProduto.image = UIImage(named: "imgProduto")
        }
    }
    
}
