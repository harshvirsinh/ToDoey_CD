//
//  ToDoListVC.swift
//  ToDoey_CD
//
//  Created by Harshvirsinh Parmar on 06/01/22.
//

import UIKit
import Lottie
class ToDoListVC: UITableViewController {
    
    // let defaults = UserDefaults.standard
    @IBOutlet var animationView: AnimationView!
    
    @IBOutlet var addItems: UIBarButtonItem!
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)

        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 0.8
        
    
        animationView.center.x = self.view.center.x
        animationView.center.y = self.view.center.y
        view.addSubview(animationView!)
        loadItems()
    }
    //MARK: -Add Items
    @IBAction func addItemsAction(_ sender: Any) {
        //Created Local Variable so that we can access it in Alert Action
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newitem = Item()
            newitem.tittle = textField.text!
            
            self.itemArray.append(newitem)
            self.tableView.reloadData()
            //Save Items To P.list
            self.saveItems()
            //save to userDefaluts.....
            //  self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            //MARK: -ThumbANimation When Item Added
            self.animationView!.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.animationView.removeFromSuperview()
            }
            self.view.addSubview(self.animationView)
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
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try! encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding Item Array,\(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self,from: data)
            }catch{
                print("Error ENcoding Items")
            }
           
        }
        
    }
    //MARK: -Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let item = itemArray[indexPath.row]
        content.text = item.tittle
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
        //        if itemArray[indexPath.row].done == false{
        //            itemArray[indexPath.row].done = true
        //        }else{
        //            itemArray[indexPath.row].done = false
        //        }
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        //  debugPrint(itemArray[indexPath.row])
    }
    
    
    
}

