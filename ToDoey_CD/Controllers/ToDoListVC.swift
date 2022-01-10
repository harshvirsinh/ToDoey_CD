//
//  ToDoListVC.swift
//  ToDoey_CD
//
//  Created by Harshvirsinh Parmar on 06/01/22.
//

import UIKit
import Lottie
import CoreData
class ToDoListVC: UITableViewController {
    
    // let defaults = UserDefaults.standard
    @IBOutlet var animationView: AnimationView!
    
    @IBOutlet var addItems: UIBarButtonItem!
    var itemArray = [Item]()
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Path Where Data Model Container....", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        animationView.animation = Animation.named("delete")
//        animationView!.contentMode = .scaleToFill
//        animationView!.loopMode = .playOnce
//        animationView!.animationSpeed = 0.7
//        animationView.center.x = self.view.center.x
//        animationView.center.y = self.view.center.y
//        view.addSubview(animationView!)
        loadItems()
    }
    //MARK: -Add Items
    @IBAction func addItemsAction(_ sender: Any) {
        //Created Local Variable so that we can access it in Alert Action
        var textField = UITextField()
        
       let action = UIAlertAction(title: "Add", style: .default) { (action) in
       
           let newitem = Item(context: self.contex)
            newitem.title = textField.text!
           newitem.done = false
            self.itemArray.append(newitem)
            self.tableView.reloadData()
           self.lottieAnimation(name: "Thumbanimate", animationSpeed: 0.8, asynceafter: 1.0)

            self.saveItems()
            //MARK: -ThumbANimation When Item Added
//            self.animationView!.play()
//           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                self.animationView.removeFromSuperview()
//            }
//            self.view.addSubview(self.animationView)
        }
        let cancleAction = UIAlertAction(title: "Cancle", style: .destructive) {(cancle) in
            self.dismiss(animated: true, completion: nil)
        }
        let alert = UIAlertController(title: "Add Items ", message: "Add Items To Your ToDO List", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New...."
            //Disable AddButton If TextField Is empty....
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:{_ in
                let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty = textCount > 0
                action.isEnabled = textIsNotEmpty
                
            })
        }
        
        action.isEnabled = false
        alert.addAction(cancleAction)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: -Lottie Animation
    private func lottieAnimation(name: String,animationSpeed: Double,asynceafter: Double){
        animationView.animation = Animation.named(name)
        animationView!.contentMode = .scaleToFill
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = animationSpeed
        animationView.center.x = self.view.center.x
        animationView.center.y = self.view.center.y
        
        animationView!.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + asynceafter) {
            self.animationView.removeFromSuperview()
        }
        view.addSubview(animationView!)
    }
    //MARK: -Encoding and decoding Items From p.List
    func saveItems(){
       
        do{
            try contex.save()
        }catch{
            print("Error Saving Contex\(error)")
        }
        self.tableView.reloadData()
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
      //  let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
           itemArray =  try contex.fetch(request)
        }
        catch{
            print("Error Fetching Items From DataModel",error)
        }
        tableView.reloadData()
    }
    //MARK: -Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let item = itemArray[indexPath.row]
        content.text = item.title
        cell.contentConfiguration = content
        cell.accessoryType = item.done ? .checkmark: .none
        //        if item.done == true{
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        return cell
        
    }
    //MARK: -Tabel View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
      //  contex.delete(itemArray[indexPath.row])
       // itemArray.remove(at: indexPath.row)
       // lottieAnimation(name: "delete", animationSpeed: 0.9, asynceafter: 2.0)
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        //  debugPrint(itemArray[indexPath.row])
    }
}
extension ToDoListVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[CD] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
}
