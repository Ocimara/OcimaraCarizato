//
//  AjustesViewController.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 21/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//

import UIKit
import CoreData

class AjustesViewController: UIViewController {
    
    
    var stateManager = StatesManager.shared
    
    let config = Configuration.shared
    var calc = Calculator.shared

    @IBOutlet weak var tfDolar: UITextField!
    @IBOutlet weak var tfIof: UITextField!
    @IBOutlet weak var tvEstados: UITableView!
    @IBOutlet weak var lbAddEstado: UIButton!
    
    
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Lista de estados vazia."
        label.textAlignment = .center
        loadValores()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        loadEstados()
    }

    override func viewWillDisappear(_ animated: Bool) {
        //aqui grava
        if tfIof.text?.isEmpty == false {
            config.txIOF = calc.verificaSinal(tfIof.text!)
         
        }
       
        if tfDolar.text?.isEmpty == false {
            config.cotDolar = calc.verificaSinal(tfDolar.text!)
        }
    }
    
    func loadValores() {
        //aqui apresenta
        tfDolar.text = config.cotDolar
        tfIof.text = config.txIOF
        
        
    }
    func loadEstados() {
        stateManager.loadStates(with: context)
        tvEstados.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //aqui grava
        if tfIof.text?.isEmpty == false {
            config.txIOF = calc.verificaSinal(tfIof.text!)
            
        }
        
        if tfDolar.text?.isEmpty == false {
            config.cotDolar = calc.verificaSinal(tfDolar.text!)
        }
        
        tfIof.resignFirstResponder()
        tfDolar.resignFirstResponder()
    }
    
    
    @IBAction func btAddEditEstado(_ sender: Any) {
        showAlert(with: nil)
        
    }
    
    func showAlert(with estado: State?) {
        let title = estado == nil ? "Adicionar Estado" : "Editar Estado"
        let btTitle = estado == nil ? "Adicionar" : "Alterar"
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nome do Estado"
            if let estUSA = estado?.title {
                textField.text = estUSA
            }
        }
        
        alert.addTextField { (txtTaxa) in
            txtTaxa.placeholder = "Imposto"
            txtTaxa.keyboardType = UIKeyboardType.decimalPad
    
            if let estTaxa = estado?.tax {
                txtTaxa.text = self.calc.getFormattedValue(of: estTaxa, withCurrency: "")
            }
        }
        
        alert.addAction(UIAlertAction(title: btTitle, style: .default, handler: {(action) in
            var errors: String = ""
            let estado = estado ?? State(context: self.context)
            
            if alert.textFields?[0].text != nil && alert.textFields?[0].text?.isEmpty == false {
                estado.title = alert.textFields?[0].text
            }
            else
            {
                errors.append("Preencha o Estado.")
            }
           
            if alert.textFields?[1].text != nil && alert.textFields?[1].text?.isEmpty == false {
                 let vlTax: String = self.calc.verificaSinal((alert.textFields?[1].text)!)
                //conforme consulta google existem estados com taxa 0
                    estado.tax = self.calc.convertDouble(vlTax)
            }
            else
            {
                errors.append("\n Preencher Taxa.")
            }
            
            if errors.description != "" && errors.description.isEmpty == false {
                self.showMsg(ptitle: "Inclusão não realizada.",pMsg: errors.description)
            }
            else
            {
                do
                {
                    try self.context.save()
                    self.loadEstados()
                }
                catch {
                    print()
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showMsg(ptitle: String, pMsg: String) {
        
        let alertController = UIAlertController(title: ptitle, message: pMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension AjustesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = stateManager.states.count
        
        tvEstados.backgroundView = count == 0 ? label : nil
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvEstados.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StateTableViewCell
        let state = stateManager.states[indexPath.row]
        cell.prepare(witch: state)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tfIof.resignFirstResponder()
        tfDolar.resignFirstResponder()
         tvEstados.deselectRow(at: indexPath, animated: false)
        
        let state = stateManager.states[indexPath.row]
        showAlert(with: state)
       
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            stateManager.deleteState(index: indexPath.row, with: context)
            stateManager.states.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
     }
}

extension AjustesViewController: UITableViewDelegate, UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tfIof.resignFirstResponder()
        tfDolar.resignFirstResponder()
        }
    
  

    
    
    
}
