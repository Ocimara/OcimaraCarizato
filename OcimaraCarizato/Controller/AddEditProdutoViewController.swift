//
//  AddEditProdutoViewController.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 19/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//

import UIKit
import CoreData

class AddEditProdutoViewController: UIViewController {
    
    var fetchedResultsController: NSFetchedResultsController<State>!

    @IBOutlet weak var tfProduto: UITextField!
    @IBOutlet weak var ivProduto: UIImageView!
    @IBOutlet weak var stCartao: UISwitch!
    @IBOutlet weak var tfEstado: UITextField!
    @IBOutlet weak var tfValorDolar: UITextField!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btAddImagem: UIButton!
    
    var produto: Product!
    var estadoSel: State!
    var image: UIImage?
    
    lazy var pvEstado: UIPickerView = {
        let pvEstado = UIPickerView()
        pvEstado.delegate = self
        pvEstado.dataSource = self
        return pvEstado
    }()
    
    var calc = Calculator.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btEspaco = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [btCancel,btEspaco,btDone]

        tfEstado.inputView = pvEstado
        tfEstado.inputAccessoryView = toolbar

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadEstados()
        
        if produto != nil {
            btAddEdit.setTitle("ALTERAR", for: .normal)
            tfProduto.text = produto.title
            if image == nil {
            if let img = produto.imgProduct as? UIImage {
                ivProduto.image = img
                self.image = img
            }
            else
            {
                ivProduto.image = UIImage(named: "imgProduto")
            }
            }
            
            stCartao.setOn(produto.flCard, animated: true)
            tfEstado.text = produto.relationState?.title
            tfValorDolar.text = calc.getFormattedValue(of: produto.vlProduct, withCurrency: "")
        }
        else
        {
            btAddEdit.setTitle("CADASTRAR", for: .normal)
        }
        
    }
    
    func loadEstados() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try    fetchedResultsController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        
        
    }
    
    @objc func cancel() {
        tfEstado.resignFirstResponder()
    }
    
    @objc func done() {
 
        if pvEstado.numberOfRows(inComponent: 0) > 0 {
            let estadoSel = fetchedResultsController.fetchedObjects![pvEstado.selectedRow(inComponent: 0)]
            tfEstado.text = estadoSel.title
        }
        cancel()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
  
    @IBAction func brAddEstado(_ sender: Any) {
        
        
        
    }
    
    @IBAction func AddImagem(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func AddEdit(_ sender: Any) {
        if produto == nil {
            produto = Product(context: context)
        }
        
        var errors: String = ""
        
        if tfProduto.text != nil && tfProduto.text?.isEmpty == false {
            produto.title = tfProduto.text
        }
        else {
            errors.append("Preencher Produto.")
        }
        
        if ivProduto.image != nil && ivProduto.image != UIImage(named: "imgProduto") {
            produto.imgProduct = image
        }
        else
        {
            errors.append("\n Selecionar Imagem.")
        }
        
        
        if tfEstado.text != nil && tfEstado.text?.isEmpty == false {
            
            let estado = fetchedResultsController.fetchedObjects?.filter({$0.title == tfEstado.text}).first
           produto.relationState = estado
        }
        else
        {
            errors.append("\n Selecionar Estado.")
        }
        if tfValorDolar.text != nil && tfValorDolar.text?.isEmpty == false {
            let vlValor = calc.verificaSinal(tfValorDolar.text!)
            if calc.convertDouble(vlValor) != 0 {
                produto.vlProduct = calc.convertDouble(vlValor)
            }
            else
            {
                errors.append("\n Valor Inválido.")
            }
        }
        else {
            errors.append("\n Preencher Valor.")
        }
        
        produto.flCard = stCartao.isOn
      
        if errors.description != "" && errors.description.isEmpty == false {
            showAlert(ptitle: "Alerta!",pMsg: errors.description)
        }
        else
        {
            do {
                try context.save()
             } catch  {
              print(error.localizedDescription)
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(ptitle: String, pMsg: String) {

        let alertController = UIAlertController(title: ptitle, message: pMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)

        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfValorDolar.resignFirstResponder()
        tfProduto.resignFirstResponder()
        tfEstado.resignFirstResponder()
    }
    
    
}

extension AddEditProdutoViewController: UIPickerViewDelegate,  UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (fetchedResultsController.fetchedObjects?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let estado = fetchedResultsController.fetchedObjects?[row].title
        return estado
    }
    
}

extension AddEditProdutoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("erro")
            return
        }
        
     let size = CGSize(width: image.size.width*0.2, height: image.size.height*0.2)
        //let size = CGSize(width: 350, height:150)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivProduto.image = self.image
    
        
        dismiss(animated: true, completion: nil)
        
    }
}

 


