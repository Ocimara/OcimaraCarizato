//
//  CalculatorValuesViewController.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 22/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//

import UIKit
import CoreData

class CalculatorValuesViewController: UIViewController {

    var fetchedResultsController: NSFetchedResultsController<Product>!
    
    @IBOutlet weak var lbVlTotDolar: UILabel!
    @IBOutlet weak var lbVlTotReal: UILabel!
    @IBOutlet weak var lbDescriptionDolar: UILabel!
    @IBOutlet weak var lbDescriptionReal: UILabel!
    let config = Configuration.shared
    var calc = Calculator.shared
    var dolar: Double = 0
    var iof: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calc.loadProducts(with: context)
        setAmmount()
    }
    
    func setAmmount() {
        //Valor do Dolar
        dolar = calc.convertDouble(calc.verificaSinal(config.cotDolar))
        //Valor do IOF
        iof = calc.convertDouble(calc.verificaSinal(config.txIOF))
        
        var totProdVlDolar: Double = 0
        var totCompraCalculada: Double = 0
        var prodCalculado: Double
        
        for prod in calc.products
        {
            //print("Nome do Produto ----> \(prod.title!)")
            //print("Valor do Produto ------->  \(prod.vlProduct)\n\n")
            
            totProdVlDolar += prod.vlProduct
            //print("Total do Produto sem imposto ---> \(totProdVlDolar)\n\n")
            
            prodCalculado = calc.calculate(pCompra: prod.vlProduct, pTaxState: (prod.relationState?.tax)!, pIof: iof, useCard: prod.flCard)
            //print("Produto Calculado em dolar com Imsposto ----> \(prodCalculado)\n\n")
            
            
            totCompraCalculada += prodCalculado
            //print("Soma dos produtos com imposto calculadacom imposto ----->\(totCompraCalculada)")
       
        }
        
        //Valor em Real
        lbVlTotReal.text = calc.getFormattedValue(of: calc.totCompraReal(vlTotCompra: totCompraCalculada, pDolar: dolar), withCurrency: "R$ ")
        
        //Valor em Dolar
        lbVlTotDolar.text = calc.getFormattedValue(of: totProdVlDolar, withCurrency: "U$ ")

        
        //Descrição dos Labels
        lbDescriptionDolar.text = "Valor total da compra em dólar sem impostos"
        lbDescriptionReal.text = "Valor total da compra em Real com impostos estaduais e IOF \n dólar (\(calc.verificaSinal(config.cotDolar))) IOF (\(calc.verificaSinal(config.txIOF)))"
    }
}
