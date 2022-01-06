//
//  ToDoListVC.swift
//  ToDoey_CD
//
//  Created by Harshvirsinh Parmar on 06/01/22.
//

import UIKit
import Lottie
class ToDoListVC: UITableViewController {
    
    @IBOutlet var animationView: AnimationView!
    
    @IBOutlet var addItems: UIBarButtonItem!
    var itemArray = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView!.contentMode = .scaleAspectFit
        
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 0.8
        animationView.center = self.view.center
        animationView.center = self.view.center
        view.addSubview(animationView!)
    }
    //MARK: -Add Items
    @IBAction func addItemsAction(_ sender: Any) {
        //Created Local Variable so that we can access it in Alert Action
        var textField = UITextField()
        let cancleAction = UIAlertAction(title: "Cancle", style: .destructive) {(cancle) in
            self.dismiss(animated: true, completion: nil)
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            print("Success")
            print(textField.text!)
            if textField.text == ""{
                textField.placeholder = "Add Somthing"
            }else{
                
                self.itemArray.append(textField.text!)
                self.tableView.reloadData()
                //MARK: -ThumbANimation When Item Added
                self.animationView!.play()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.animationView.removeFromSuperview()
                }
                self.view.addSubview(self.animationView)
                
            }
            
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
            print(alertTextField)
        }
        
        action.isEnabled = false
        alert.addAction(cancleAction)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: -Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = itemArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
        
    }
    //MARK: -Tabel View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        debugPrint(itemArray[indexPath.row])
    }
    
    
    
}

