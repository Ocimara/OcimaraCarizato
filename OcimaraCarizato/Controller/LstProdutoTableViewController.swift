//
//  LstProdutoTableViewController.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 19/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//

import UIKit
import CoreData

class LstProdutoTableViewController: UITableViewController {

    var fetchedResultsController: NSFetchedResultsController<Product>!
    
    var lbValida = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbValida.text = "Sua lista está vazia!"
        lbValida.textAlignment = .center
        loadProdutos()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "sgEditProduto" {
            let vc = segue.destination as! AddEditProdutoViewController
            if let prods = fetchedResultsController.fetchedObjects {
                vc.produto = prods[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func loadProdutos() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
    
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try    fetchedResultsController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        
        tableView.backgroundView = count == 0 ? lbValida : nil
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProdutoTableViewCell
        
        guard let produto = fetchedResultsController.fetchedObjects?[indexPath.row] else {
            
            return cell
            
        }
        
        cell.prepare(witch: produto)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let produto = fetchedResultsController.fetchedObjects?[indexPath.row] else {return}
            do {
                context.delete(produto)
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

// MARK: - EXTENSION
extension LstProdutoTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        
    }
    
}

